class Department < ApplicationRecord
  belongs_to :parent_department,
             class_name:  'Department',
             foreign_key: 'parent_department_id',
             optional:    true

  has_many :positions
  has_many :employees, through: :positions
end