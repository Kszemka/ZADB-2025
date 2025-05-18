class Employee < ApplicationRecord
  belongs_to :manager,
    class_name:  'Employee',
    foreign_key: "manager_id",
    optional: true
  
  belongs_to :position
end
