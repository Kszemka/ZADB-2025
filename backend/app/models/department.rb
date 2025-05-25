class Department < ApplicationRecord
  belongs_to :parent_department,
             class_name:  'Department',
             foreign_key: 'parent_department_id',
             optional:    true

  has_many :positions
  has_many :employees, through: :positions

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      name
      parent_department_id
      created_at
      updated_at
    ]
  end
end