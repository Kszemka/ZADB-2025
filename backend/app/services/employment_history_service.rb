class EmploymentHistoryService
  class << self
    attr_accessor :employment_history
  end

  def self.add_new_record(ctx)
    EmploymentHistory.transaction do
      now = Time.current

      self.employment_history = EmploymentHistory.create!(
        employee:   ctx.employee,
        position:   ctx.position,
        department: ctx.department,
        manager:    ctx.manager,
        start_date: ctx.start_date,
        end_date:   ctx.end_date,
        created_at: now,
        updated_at: now
      )
    end
  end

  def self.delete_employee_id(id)
    EmploymentHistory.transaction do
      EmploymentHistory.where(employee_id: id).delete_all
      EmploymentHistory.where(manager_id: id).update_all(manager_id: nil)
    end
  end
end
