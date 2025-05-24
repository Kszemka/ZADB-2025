class PositionCreateValidator < ActiveModel::Validator
  def validate(record)
    if record.job.nil? || record.department.nil?
      record.errors.add(:base, "You must specify a job and a department.")
    end
    if record.location.nil?
      record.errors.add(:base, "You must specify a location. If location is new, add new location first.")
    end
  end
end