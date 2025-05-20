require 'ostruct'

class EmployeeService
  class << self
    attr_accessor :employee
  end

  def self.add_employee_to_open_position(ctx)
    now = Time.current

    Employee.transaction do
      created = Employee.create!(
        first_name:  ctx.first_name,
        last_name:   ctx.last_name,
        email:       ctx.email,
        manager:     ctx.manager,
        position:    ctx.position,
        hire_date:   now.to_date,
        created_at:  now.to_date,
        updated_at:  now.to_date,
        is_active:   true
      )

      ::EmploymentHistoryService.add_new_record(
        OpenStruct.new(
          employee:   created,
          position:   created.position,
          department: created.position.department,
          manager:    created.manager,
          start_date: now.to_date,
          end_date:   nil
        )
      )

      created.position.update!(status: Position::OCCUPIED)

      self.employee = created
    end
  end

  # https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
  def self.update_employee_information(ctx)
    now        = Time.current
    employee   = ctx.employee

    Employee.transaction do
      if (ctx.position && ctx.position != employee.position) ||
        (ctx.manager  && ctx.manager  != employee.manager)
        ::EmploymentHistoryService.add_new_record(
          OpenStruct.new(
            employee:   employee,
            position:   (ctx.position || employee.position),
            department: (ctx.position.department || employee.position.department),
            manager:    (ctx.manager || employee.manager),
            start_date: employee.hire_date,
            end_date:   now.to_date
          )
        )
      end

      updates = {}
      updates[:first_name] = ctx.first_name if ctx.first_name.present?
      updates[:last_name]  = ctx.last_name  if ctx.last_name.present?
      updates[:email]      = ctx.email      if ctx.email.present?
      updates[:manager]    = ctx.manager    if ctx.manager && ctx.manager != employee.manager
      updates[:position]   = ctx.position   if ctx.position && ctx.position != employee.position

      employee.update!(updates) unless updates.empty?

      if updates.key?(:position)
        employee.position.update!(status: Position::OCCUPIED)
      end

      self.employee = employee.reload
    end
  end

  def self.delete_employee_information(ctx)
    employee = ctx.employee
    last_position = employee.position

    Employee.transaction do
      Employee.where(manager_id: employee.id).update_all(manager_id: nil)

      EmploymentHistoryService.delete_employee_id(employee.id)

      employee.destroy!

      last_position.update!(status: Position::OPEN)

      self.employee = employee
    end
  end

  def self.fire_employee(ctx)
    employee = ctx.employee
    last_position = employee.position

    Employee.transaction do
      employee.update!(is_active: false)
      last_position.update!(status: Position::OPEN)

      self.employee = employee
    end
  end
end
