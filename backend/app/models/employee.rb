class Employee < ApplicationRecord
  belongs_to :manager,
    class_name:  'Employee',
    foreign_key: 'manager_id',
    optional: true
  has_one :compensation, dependent: :destroy
  has_many :employment_histories,
           foreign_key: 'employee_id',
           dependent: :destroy
  
  belongs_to :position

  has_and_belongs_to_many :projects

  def position_name
    position&.job&.title
  end

  def compensation_data
    return nil unless compensation

    {
      amount: compensation.amount,
      currency: compensation.currency
    }
  end

  def as_json(options = {})
    super(
      only: [:id, :first_name, :last_name, :email, :hire_date, :is_active, :position_history_ids],
      methods: [:position_name, :compensation_data]
    )
  end
end
