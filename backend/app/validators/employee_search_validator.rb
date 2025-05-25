class EmployeeSearchValidator < ActiveModel::Validator
  def validate(record)
    allowed_columns = Employee::EmployeeSearchInteractor::EMPLOYEE_COLUMNS

    if record.filter_by.present? && !allowed_columns.include?(record.filter_by)
      record.errors.add(:filter_by, "is not a valid column.")
    end

    if record.group_by.present? && !allowed_columns.include?(record.group_by)
      record.errors.add(:group_by, "is not a valid column.")
    end

    if record.order_by.present? && !allowed_columns.include?(record.order_by)
      record.errors.add(:order_by, "is not a valid column.")
    end

    if record.order_by.present? && record.group_by.present?
      record.errors.add(:order_by, "is not processable by the group_by column.")
    end
  end
end
