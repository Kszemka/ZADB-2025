class Employee::EmployeeProjectInteractor < ResponseService
  string :email, default: nil

  validates :email, presence: true

  def execute
    EmployeeService.search_projects(search_param)
  end

  private

  def search_param
    {:email => email}
  end
end
