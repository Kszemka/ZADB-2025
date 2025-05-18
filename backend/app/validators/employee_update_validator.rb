class EmployeeUpdateValidator < ActiveModel::Validator
  def validate(record)
    if record.employee.nil?
      record.errors.add(:base, "Employee does not exist.")
    elsif record.first_name && record.employee.first_name != record.first_name
      record.errors.add(:base, "Employee name is not correct.")
    elsif record.last_name && record.employee.last_name != record.last_name
      record.errors.add(:base, "Employee last_name is not correct.")
    end
  end
end