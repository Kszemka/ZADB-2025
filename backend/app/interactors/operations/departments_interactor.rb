class Operations::DepartmentsInteractor < ResponseService
  string  :name,                  default: nil
  string  :employee_mail,         default: nil
  integer :parent_department_id,  default: nil

  ALLOWED_SEARCH_PARAMS = %w[
    name
    parent_department_id
    employee_mail
  ].freeze

  validate :exactly_one_param

  def execute
    param, value = {
      'name'                 => name,
      'parent_department_id' => parent_department_id,
      'employee_mail'        => employee_mail
    }.find { |_, v| v.present? }

    DepartmentsService.search_with_param(param, value)
  end

  private

  def exactly_one_param
    present = [
      name.present?,
      parent_department_id.present?,
      employee_mail.present?
    ].count(true)

    if present.zero?
      errors.add(:base, "You must provide one of: #{ALLOWED_SEARCH_PARAMS.join(', ')}")
    elsif present > 1
      errors.add(:base, "Please provide only one of: #{ALLOWED_SEARCH_PARAMS.join(', ')}")
    end
  end
end
