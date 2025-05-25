class Job < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      code
      id_value
      title
      min_salary
      max_salary
      created_at
      updated_at
    ]
  end
end
