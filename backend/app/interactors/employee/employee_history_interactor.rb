class Employee::EmployeeHistoryInteractor < ResponseService
  string :email, default: nil

  validates :email, presence: true

  def execute
    EmployeeService.search_history(search_param)
  end

  def search_history(search_param)
    EmployeeService.search_history(search_param)
  end

  private
  def search_param
    {:email => email}
  end
end
