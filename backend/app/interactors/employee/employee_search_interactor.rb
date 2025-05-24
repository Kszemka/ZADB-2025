class Employee::EmployeeSearchInteractor < ResponseService
  string :filter_by, default: nil
  string :filter_val, default: nil
  string :group_by, default: nil
  string :order_by, default: nil
  string :order_val, default: nil

  EMPLOYEE_COLUMNS = %w[
    id first_name last_name email hire_date manager_id position_id
    created_at updated_at is_active
  ].freeze

  validates_with EmployeeSearchValidator

  with_options if: -> { filter_by.present? } do
    validates :filter_val, presence: true
  end

  with_options if: -> { order_by.present? } do
    validates :order_val, presence: true
    validates :order_val, inclusion: { in: %w[asc desc], message: "must be 'asc' or 'desc'" }
  end

  def execute
    EmployeeService.search_employees(self)
  end
end
