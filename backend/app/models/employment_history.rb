class EmploymentHistory < ApplicationRecord
  belongs_to :employee, class_name: '::Employee', foreign_key: 'employee_id'
  belongs_to :position
  belongs_to :department
  belongs_to :manager,  class_name: '::Employee', foreign_key: 'manager_id'
end
