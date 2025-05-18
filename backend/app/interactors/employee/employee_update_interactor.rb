class Employee::EmployeeUpdateInteractor < ResponseService
  string  :first_name, default: nil
  string  :last_name,  default: nil
  string  :email
  integer :manager_id,  default: nil
  integer :position_id, default: nil

  attr_reader :employee, :manager, :position

  set_callback :validate, :before, :set_employee
  set_callback :validate, :before, :set_associations, if: -> { employee.present? }

  validates :email, presence: true
  validates_with EmployeeUpdateValidator
  validates_with EmployeeAddValidator, if: -> { employee.present? }

  def execute
    EmployeeService.update_employee_information(self)
  end

  private

  def set_employee
    @employee = Employee.find_by(email: email)
  end

  def set_associations

    if !position_id.nil?
      @position = Position.find_by(id: position_id)
    else
      @position = employee.position
    end

    if !manager_id.nil?
      @manager  = Employee.find_by(id: manager_id)
    else
      @manager = employee.manager
    end
  end

end
