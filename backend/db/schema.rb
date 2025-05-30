ActiveRecord::Schema[7.2].define(version: 2025_05_18_010417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Departments
  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.integer "parent_department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "departments", ["parent_department_id"], name: "index_departments_on_parent_department"

  # Locations
  create_table "locations", force: :cascade do |t|
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  # Jobs
  create_table "jobs", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.decimal "min_salary", precision: 10, scale: 2
    t.decimal "max_salary", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "jobs", ["code"], name: "index_jobs_on_code", unique: true

  # Positions
  create_table "positions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "department_id", null: false
    t.bigint "location_id", null: false
    t.string "status", null: false, default: "OPEN"
    t.date "posted_date", null: false, default: -> { "CURRENT_DATE" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "positions", ["status"], name: "index_positions_on_status"
  add_foreign_key "positions", "jobs"
  add_foreign_key "positions", "departments"
  add_foreign_key "positions", "locations"
  add_check_constraint "positions", "status IN ( #{Position::STATUSES.map { |s| "'#{s}'" }.join(", ")} )", name: "positions_status_check"

  # Employees
  create_table "employees", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.date "hire_date", null: false
    t.bigint "manager_id"
    t.bigint "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "position_history_ids", null: false, default: []
    t.boolean "is_active", null: false
  end
  add_index "employees", ["email"], name: "index_employees_on_email", unique: true
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "employees", "positions"

  # Employment Histories
  create_table "employment_histories", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "position_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.bigint "department_id", null: false
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_foreign_key "employment_histories", "employees", foreign_key: { on_delete: :cascade }
  add_foreign_key "employment_histories", "positions"
  add_foreign_key "employment_histories", "departments"
  add_foreign_key "employment_histories", "employees", column: "manager_id"

  # Compensations
  create_table "compensations", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.string "currency", limit: 3, null: false, default: "PLN"
    t.date "effective_date", null: false
    t.string "frequency", null: false, default: "MONTHLY"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_foreign_key "compensations", "employees"

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "projects", ["code"], name: "index_projects_on_code", unique: true

  create_table "employees_projects", id: false, force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "project_id", null: false
  end
  add_index "employees_projects", ["employee_id", "project_id"], name: "index_employees_projects_on_employee_and_project", unique: true
  add_index "employees_projects", ["project_id", "employee_id"], name: "index_employees_projects_on_project_and_employee"
  add_foreign_key "employees_projects", "employees"
  add_foreign_key "employees_projects", "projects"

  create_table :operations do |t|
    t.string :name, null: false
    t.integer :counter, default: 0
    t.timestamps
  end

  add_index :operations, :name, unique: true

  reversible do |dir|
    dir.up do
      execute <<-SQL.squish
            CREATE FUNCTION increment_operation_counter()
            RETURNS TRIGGER AS $$
            BEGIN
              INSERT INTO operations (name, counter, created_at, updated_at)
              VALUES ('employee', 1, NOW(), NOW())
              ON CONFLICT (name) DO UPDATE
              SET counter = operations.counter + 1,
                  updated_at = NOW();
              RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;
  
            CREATE TRIGGER increment_operation_trigger
            AFTER INSERT OR UPDATE OR DELETE ON employees
            FOR EACH ROW
            EXECUTE PROCEDURE increment_operation_counter();
      SQL

      execute <<-SQL
            CREATE FUNCTION increment_positions_operation()
            RETURNS TRIGGER AS $$
            BEGIN
              INSERT INTO operations (name, counter, created_at, updated_at)
              VALUES ('employment_history_insert', 1, NOW(), NOW())
              ON CONFLICT (name) DO UPDATE
              SET counter = operations.counter + 1,
                  updated_at = NOW();
              RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;
  
            CREATE TRIGGER increment_positions_trigger
            AFTER INSERT ON employment_histories
            FOR EACH ROW
            EXECUTE PROCEDURE increment_positions_operation();
      SQL

      execute <<-SQL
-- wersja funkcyjna na db na podstawie obsługi EmployeeService::delete_employee_information()
CREATE OR REPLACE PROCEDURE soft_delete_employee(p_employee_id BIGINT)
LANGUAGE plpgsql AS $$
DECLARE
  v_position_id BIGINT;
BEGIN
  -- 1. Pobierz przypisaną pozycję
  SELECT position_id INTO v_position_id FROM employees WHERE id = p_employee_id;

  -- 2. Odłącz podwładnych
  UPDATE employees
  SET manager_id = NULL
  WHERE manager_id = p_employee_id;

  -- 3. Usuń historię zatrudnienia
  DELETE FROM employment_histories
  WHERE employee_id = p_employee_id;

  -- 4. Oznacz pracownika jako nieaktywny
  UPDATE employees
  SET is_active = FALSE
  WHERE id = p_employee_id;

  -- 5. Ustaw status pozycji na 'OPEN'
  UPDATE positions
  SET status = 'OPEN'
  WHERE id = v_position_id;
END;
$$;
      SQL
    end

    dir.down do
      execute "DROP TRIGGER IF EXISTS increment_operation_trigger ON employees"
      execute "DROP FUNCTION IF EXISTS increment_operation_counter()"
    end
  end
end
