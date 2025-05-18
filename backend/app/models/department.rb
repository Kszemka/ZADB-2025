class Department < ApplicationRecord
  belongs_to :parent_department,
             class_name:  'Department',
             foreign_key: 'parent_department_id',
             optional:    true
end
