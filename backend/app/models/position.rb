class Position < ApplicationRecord
  belongs_to :job
  belongs_to :department
  belongs_to :location
end
