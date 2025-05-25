require 'ostruct'

class EmployeeService
  class << self
    attr_accessor :employee

    def search_employees(params)
      employees = Employee.all

      if params.filter_by.present?
        type, column, value = build_filter_condition(params.filter_by, params.filter_val)

        case type
        when :exact
          employees = employees.where(column => value)
        when :ilike
          employees = employees.where("#{column} ILIKE ?", value)
        when :invalid
          employees = employees.none
        end
      end

      if params.group_by.present?
        group_column = params.group_by

        employees = employees
                      .group(params.group_by)
                      .pluck(params.group_by, Arel.sql("COUNT(*)"))
                      .map { |group_val, count| { group_column => group_val, count: count } }
      end

      if params.order_by.present?
        direction = params.order_val.to_s.downcase == 'desc' ? :desc : :asc
        employees = employees.order(params.order_by => direction)
      end

      employees
    end

    def search_projects(params)
      Employee.find_by(email: params[:email]).projects.pluck(:name)
    end

    def search_history(params)
      Employee.find_by(email: params[:email])&.employment_histories
    end

    def give_raise(params)
      raise_percent = params[:raise].to_f

      ActiveRecord::Base.transaction do
        Compensation.find_each do |comp|
          new_amount = (comp.amount * (1 + raise_percent / 100)).round(2)
          comp.update!(amount: new_amount)
        end
      end

      :ok
    rescue => e
      :rollback
    end

    def add_employee_to_open_position(params)
      now = Date.current

      Employee.transaction do
        created = Employee.create!(
          first_name: params.first_name,
          last_name:  params.last_name,
          email:      params.email,
          manager:    params.manager,
          position:   params.position,
          hire_date:  now,
          created_at: now,
          updated_at: now,
          is_active:  true
        )

        history = ::EmploymentHistoryService.add_new_record(
          OpenStruct.new(
            employee:   created,
            position:   created.position,
            department: created.position.department,
            manager:    created.manager,
            start_date: now,
            end_date:   nil
          )
        )

        created.update!(position_history_ids: [history.position.id])

        created.position.update!(status: Position::OCCUPIED)

        self.employee = created
      end
    end

    def update_employee_information(params)
      now = Date.current
      employee = params.employee
      old_position = employee.position

      Employee.transaction do
        if (params.position && params.position != employee.position) ||
          (params.manager && params.manager != employee.manager)
          history = ::EmploymentHistoryService.add_new_record(
            OpenStruct.new(
              employee:   employee,
              position:   (params.position || employee.position),
              department: (params.position.department || employee.position.department),
              manager:    (params.manager || employee.manager),
              start_date: employee.hire_date,
              end_date:   now
            )
          )
          employee.update!(position_history_ids: employee.position_history_ids + [history.position.id])
        end

        updates = {}
        updates[:first_name] = params.first_name if params.first_name.present?
        updates[:last_name]  = params.last_name  if params.last_name.present?
        updates[:email]      = params.email      if params.email.present?
        updates[:manager]    = params.manager    if params.manager && params.manager != employee.manager
        updates[:position]   = params.position   if params.position && params.position != employee.position

        employee.update!(updates) unless updates.empty?

        if updates.key?(:position)
          employee.position.update!(status: Position::OCCUPIED)
          old_position.update!(status: Position::OPEN)
        end

        self.employee = employee.reload
      end
    end

    def delete_employee_information(params)
      employee = params.employee
      last_position = employee.position

      Employee.transaction do
        Employee.where(manager_id: employee.id).update_all(manager_id: nil)
        EmploymentHistoryService.delete_employee_id(employee.id)
        employee.destroy!
        last_position.update!(status: Position::OPEN)

        self.employee = employee
      end
    end

    def fire_employee(params)
      employee = params.employee
      last_position = employee.position

      Employee.transaction do
        employee.update!(is_active: false)
        last_position.update!(status: Position::OPEN)

        self.employee = employee
      end
    end

    private

    def build_filter_condition(column, value)
      if %w[id manager_id position_id].include?(column)
        [:exact, column, value.to_i]
      elsif %w[is_active].include?(column)
        [:exact, column, ActiveModel::Type::Boolean.new.cast(value)]
      elsif %w[hire_date created_at updated_at].include?(column)
        begin
          date = Date.parse(value)
          range = date.beginning_of_day..date.end_of_day
          [:range, column, range]
        rescue ArgumentError
          [:invalid, nil, nil]
        end
      else
        [:ilike, column, "%#{value}%"]
      end
    end
  end
end
