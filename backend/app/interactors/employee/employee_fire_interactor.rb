class Employee::EmployeeFireInteractor < ResponseService
  string  :first_name, default: nil
  string  :last_name,  default: nil
  string  :email

  attr_reader :employee

  set_callback :validate, :before, :set_employee

  validates :email, presence: true
  validates_with EmployeeUpdateValidator

  def execute
    employee
  end

  def delete_soft

  end

  def delete_hard
    EmployeeService.delete_employee_information(self)
  end

  private

  def set_employee
    @employee = Employee.find_by(email: email)
  end

end
