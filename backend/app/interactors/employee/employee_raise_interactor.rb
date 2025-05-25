class Employee::EmployeeRaiseInteractor < ResponseService
  integer :raise

  validates :raise, presence: true, numericality: { greater_than: 0 }

  def execute
    EmployeeService.give_raise({:raise => self.raise})
  end
end
