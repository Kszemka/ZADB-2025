class Position < ApplicationRecord
  OPEN = 'OPEN'.freeze
  OCCUPIED = 'OCCUPIED'.freeze
  STATUSES = [OPEN, OCCUPIED].freeze

  belongs_to :job
  belongs_to :department
  belongs_to :location

  has_many :employees

  def as_json(options = {})
    super(
      only: [:id, :status, :posted_date, :created_at, :updated_at],
      methods: [:job_title, :department_name, :location_country]
    )
  end

  def job_title
    job&.title
  end

  def department_name
    department&.name
  end

  def location_country
    location&.country
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      status
      posted_date
      created_at
      updated_at
      job_id
      department_id
      location_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      job
      department
      location
      employees
    ]
  end

end
