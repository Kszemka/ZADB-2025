class EmploymentHistory < ApplicationRecord
  belongs_to :employee
  belongs_to :position
  belongs_to :department
  belongs_to :manager,
    class_name: "Employee",
    foreign_key: "manager_id",
    optional: true
end
