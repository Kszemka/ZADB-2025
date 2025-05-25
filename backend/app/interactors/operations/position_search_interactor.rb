class Operations::PositionSearchInteractor < ResponseService
  string :job_name, default: nil
  string :department_name, default: nil
  string :status, default: nil
  string :employee_mail, default: nil
  string :location, default: nil

  ALLOWED_SEARCH_PARAMS = %w[
    job_name
    department_name
    status
    employee_mail
    location
  ].freeze

  validate :at_least_one_param

  def execute
    search_params = {
      :job_name => job_name,
      :department_name => department_name,
      :status => status,
      :employee_mail => employee_mail,
      :location => location
    }.compact_blank

    PositionService.search_with_params(search_params)
  end

  private

  def at_least_one_param
    present = ALLOWED_SEARCH_PARAMS.map { |param| send(param).present? }.count(true)
    if present.zero?
      errors.add(:base, "You must provide at least one of: #{ALLOWED_SEARCH_PARAMS.join(', ')}")
    end
  end
end
