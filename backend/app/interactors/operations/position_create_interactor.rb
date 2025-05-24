class Operations::PositionCreateInteractor < ResponseService
  string  :job_code
  string  :department_name
  string  :location

  attr_reader :job, :department, :location

  set_callback :validate, :before, -> do
    set_attr
  end

  validates :job_code, :department_name, :location, presence:true
  validates_with PositionCreateValidator

  def execute
    PositionService.create(self)
  end

  private
  def set_attr
    @job = Job.find_by(code: job_code)
    @department  = DepartmentsService.search_with_param("name", department_name)
    @location = Location.find_by(city: location)
  end

end
