# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_05_18_010417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

    # Departments
    create_table "departments", force: :cascade do |t|
      t.string   "name",               null: false
      t.integer  "parent_department_id"
      t.datetime "created_at",         null: false
      t.datetime "updated_at",         null: false
    end
    add_index "departments", ["parent_department_id"], name: "index_departments_on_parent_department"
  
    # Locations
    create_table "locations", force: :cascade do |t|
      t.string   "city"
      t.string   "state"
      t.string   "country"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  
    # Jobs
    create_table "jobs", force: :cascade do |t|
      t.string   "code",       null: false
      t.string   "title",      null: false
      t.decimal  "min_salary", precision: 10, scale: 2
      t.decimal  "max_salary", precision: 10, scale: 2
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    add_index "jobs", ["code"], name: "index_jobs_on_code", unique: true
  
    # Positions
    create_table "positions", force: :cascade do |t|
      t.bigint   "job_id",        null: false
      t.bigint   "department_id", null: false
      t.bigint   "location_id",   null: false
      t.string   "status",        null: false, default: "OPEN"
      t.date     "posted_date",   null: false, default: -> { "CURRENT_DATE" }
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
    end
    add_index "positions", ["status"], name: "index_positions_on_status"
    add_foreign_key "positions", "jobs"
    add_foreign_key "positions", "departments"
    add_foreign_key "positions", "locations"
  
    # Employees
    create_table "employees", force: :cascade do |t|
      t.string   "first_name",  null: false
      t.string   "last_name",   null: false
      t.string   "email",       null: false
      t.date     "hire_date",   null: false
      t.bigint   "manager_id"
      t.bigint   "department_id"
      t.bigint   "position_id"
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
    end
    add_index "employees", ["email"], name: "index_employees_on_email", unique: true
    add_index "employees", ["department_id"], name: "index_employees_on_department_id"
    add_foreign_key "employees", "employees", column: "manager_id"
    add_foreign_key "employees", "departments"
    add_foreign_key "employees", "positions"
  
    # Employment Histories
    create_table "employment_histories", force: :cascade do |t|
      t.bigint   "employee_id",  null: false
      t.bigint   "position_id",  null: false
      t.date     "start_date",   null: false
      t.date     "end_date"
      t.bigint   "department_id", null: false
      t.bigint   "manager_id"
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
    end
    add_foreign_key "employment_histories", "employees"
    add_foreign_key "employment_histories", "positions"
    add_foreign_key "employment_histories", "departments"
    add_foreign_key "employment_histories", "employees", column: "manager_id"
  
    # Compensations
    create_table "compensations", force: :cascade do |t|
      t.bigint   "employee_id",  null: false
      t.decimal  "amount",       precision: 12, scale: 2, null: false
      t.string   "currency",     limit: 3,     null: false, default: "PLN"
      t.date     "effective_date", null: false
      t.string   "frequency",    null: false, default: "MONTHLY"
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
    end
    add_index "compensations", ["effective_date"], name: "index_compensations_on_effective_date"
    add_foreign_key "compensations", "employees"
  
    # Time Off Requests
    create_table "time_off_requests", force: :cascade do |t|
      t.bigint   "employee_id",   null: false
      t.string   "request_type",  null: false
      t.date     "start_date",    null: false
      t.date     "end_date",      null: false
      t.string   "status",        null: false, default: "PENDING"
      t.date     "requested_date", null: false, default: -> { "CURRENT_DATE" }
      t.bigint   "approved_by"
      t.date     "approved_date"
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
    end
    add_index "time_off_requests", ["status"], name: "index_time_off_requests_on_status"
    add_foreign_key "time_off_requests", "employees"
    add_foreign_key "time_off_requests", "employees", column: "approved_by"
  
  end
