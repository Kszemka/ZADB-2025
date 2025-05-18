class EmployeeAddValidator < ActiveModel::Validator
  def validate(record)
    if record.position.nil?
      record.errors.add(:base, "Wrong position id.")
    end
    if !record.position.nil? && record.position.status != Position::OPEN
      record.errors.add(:base, "Position status is wrong.")
    end
    if record.manager.nil?
      record.errors.add(:base, "Wrong manager id.")
    end
  end
end