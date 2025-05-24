class PositionService
  class << self
    attr_accessor :positions
  end

  def self.search_with_param(param_name, value)

    result = case param_name
          when 'job_name'
            pattern = "%#{value}%"
            Position.joins(:job)
                    .where('jobs.title ILIKE ?', pattern)
          when 'department_name'
            pattern = "%#{value}%"
            Position.joins(:department)
                    .where('departments.name ILIKE ?', pattern)
          when 'status'
            Position.find_by(status: value)
          when 'employee_mail'
            Position.joins(:employees)
                    .where(employees: { email: value })
          when 'location'
            Position.joins(:locations)
                    .where(locations: { country: value })
          end

    self.positions = result
  end

  def self.create(ctx)
    Position.transaction do
      created = Position.create!(
        job_id:        ctx.job,
        department_id: ctx.department,
        location_id:   ctx.location,
        status:        Position::OPEN,
        posted_date:   Date.current
        )
      self.position = created
    end
  end

  def self.update(ctx)
    Position.transaction do
      pos = Position.find(ctx.id)
      updates = {}
      updates[:job_id]        = ctx.job_id        if ctx.respond_to?(:job_id) && ctx.job_id.present?
      updates[:department_id] = ctx.department_id if ctx.respond_to?(:department_id) && ctx.department_id.present?
      updates[:location_id]   = ctx.location_id   if ctx.respond_to?(:location_id) && ctx.location_id.present?
      updates[:status]        = ctx.status        if ctx.respond_to?(:status) && ctx.status.present?
      updates[:posted_date]   = ctx.posted_date   if ctx.respond_to?(:posted_date) && ctx.posted_date.present?

      pos.update!(updates) unless updates.empty?
      self.position = pos.reload
    end
  end

  def self.delete(ctx)
    Position.transaction do
      pos = Position.find(ctx.id)
      pos.destroy!
      self.position = pos
    end
  end
end