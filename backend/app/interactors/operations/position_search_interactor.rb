class Operations::PositionSearchInteractor < ResponseService
  string  :job_name,              default: nil
  string  :department_name,       default: nil
  string  :status,                default: nil
  string  :employee_mail,         default: nil
  string  :location,         default: nil

  ALLOWED_SEARCH_PARAMS = %w[
    job_name
    department_name
    status
    employee_mail
    location
  ].freeze

  validate :exactly_one_param

  def execute
    param, value = {
      'job_name' => job_name,
      'department_name' => department_name,
      'status' => status,
      'employee_mail' => employee_mail,
      'location' => location
    }.find { |_, v| v.present? }

    PositionService.search_with_param(param, value)
  end

  private

  def exactly_one_param
    present = [
      job_name.present?,
      department_name.present?,
      status.present?,
      employee_mail.present?,
      location.present?
    ].count(true)

    if present.zero?
      errors.add(:base, "You must provide one of: #{ALLOWED_SEARCH_PARAMS.join(', ')}")
    elsif present > 1
      errors.add(:base, "Please provide only one of: #{ALLOWED_SEARCH_PARAMS.join(', ')}")
    end
  end
end
