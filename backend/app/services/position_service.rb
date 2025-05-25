class PositionService
  class << self
    attr_accessor :positions, :position

    def search_with_params(params)
      self.positions = Position.ransack(build_ransack_query(params)).result(distinct: true)
    end

    def create(params)
      Position.transaction do
        created = Position.create!(
          job_id:        params.job,
          department_id: params.department,
          location_id:   params.location,
          status:        Position::OPEN,
          posted_date:   Date.current
        )
        self.position = created
      end
    end

    def update(params)
      Position.transaction do
        pos = Position.find(params.id)

        updates = {}
        updates[:job_id]        = params.job_id        if params.respond_to?(:job_id)        && params.job_id.present?
        updates[:department_id] = params.department_id if params.respond_to?(:department_id) && params.department_id.present?
        updates[:location_id]   = params.location_id   if params.respond_to?(:location_id)   && params.location_id.present?
        updates[:status]        = params.status        if params.respond_to?(:status)        && params.status.present?
        updates[:posted_date]   = params.posted_date   if params.respond_to?(:posted_date)   && params.posted_date.present?

        pos.update!(updates) unless updates.empty?
        self.position = pos.reload
      end
    end

    def delete(params)
      Position.transaction do
        pos = Position.find(params.id)
        pos.destroy!
        self.position = pos
      end
    end

    private

    def build_ransack_query(params)
      query = {}

      query["job_title_i_cont"]         = params[:job_name]         if params[:job_name].present?
      query["department_name_i_cont"]   = params[:department_name]  if params[:department_name].present?
      query["status_eq"]                = params[:status]           if params[:status].present?
      query["employees_email_eq"]       = params[:employee_mail]    if params[:employee_mail].present?
      query["locations_country_eq"]     = params[:location]         if params[:location].present?

      query
    end
  end
end
