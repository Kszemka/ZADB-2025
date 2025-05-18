class DepartmentsService
  class << self
    attr_accessor :department
  end

  def self.search_with_param(param_name, value)

    if param_name == 'employee_mail'
      Department
        .joins(positions: :employees)
        .where(employees: { email: value })
        .distinct
    else
      Department.where(param_name => value)
    end
  end

end
