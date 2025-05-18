class Position < ApplicationRecord
  OPEN     = 'OPEN'.freeze
  OCCUPIED = 'OCCUPIED'.freeze
  STATUSES = [OPEN, OCCUPIED].freeze

  belongs_to :job
  belongs_to :department
  belongs_to :location

  has_many   :employees
end
