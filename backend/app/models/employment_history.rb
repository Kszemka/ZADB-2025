class EmploymentHistory < ApplicationRecord
  belongs_to :employee, class_name: 'Employee', foreign_key: 'employee_id'
  belongs_to :position
  belongs_to :department
  belongs_to :manager, class_name: 'Employee', foreign_key: 'manager_id', optional: true

  def as_json(options = {})
    super(
      only: [:id, :start_date, :end_date, :created_at, :updated_at],
      methods: [:employee_email, :position_name, :department_name, :manager_email]
    )
  end

  def employee_email
    employee&.email
  end

  def manager_email
    manager&.email
  end

  def position_name
    position&.job&.title
  end

  def department_name
    department&.name
  end
end
