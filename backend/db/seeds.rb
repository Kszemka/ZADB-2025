ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

# Departments
Department.create!(name: 'Head Office')
Department.create!(name: 'Human Resources', parent_department: Department.find_by(name: 'Head Office'))
Department.create!(name: 'IT',              parent_department: Department.find_by(name: 'Head Office'))
Department.create!(name: 'Finance',         parent_department: Department.find_by(name: 'Head Office'))

# Locations
Location.create!(city: 'Warsaw',   state: 'Mazowieckie',    country: 'Poland')
Location.create!(city: 'Kraków',   state: 'Małopolskie',    country: 'Poland')
Location.create!(city: 'London',   state: 'Greater London', country: 'UK')
Location.create!(city: 'New York', state: 'NY',             country: 'USA')

# Jobs
Job.create!(code: 'HR_SPEC', title: 'HR Specialist',       min_salary: 4000,  max_salary: 7000)
Job.create!(code: 'ENG_I',   title: 'Software Engineer I', min_salary: 8000,  max_salary: 12000)
Job.create!(code: 'FIN_MGR', title: 'Finance Manager',     min_salary: 10000, max_salary: 15000)

# Positions
Position.create!(
  job:          Job.find_by(code: 'ENG_I'),
  department:   Department.find_by(name: 'IT'),
  location:     Location.find_by(city: 'Warsaw'),
  status:       Position::OCCUPIED,
  posted_date:  '2024-01-10'
)
Position.create!(
  job:          Job.find_by(code: 'HR_SPEC'),
  department:   Department.find_by(name: 'Human Resources'),
  location:     Location.find_by(city: 'Warsaw'),
  status:       Position::OCCUPIED,
  posted_date:  '2024-02-15'
)
Position.create!(
  job:          Job.find_by(code: 'FIN_MGR'),
  department:   Department.find_by(name: 'Finance'),
  location:     Location.find_by(city: 'New York'),
  status:       Position::OCCUPIED,
  posted_date:  '2025-05-01'
)
Position.create!(
  job:          Job.find_by(code: 'ENG_I'),
  department:   Department.find_by(name: 'IT'),
  location:     Location.find_by(city: 'Kraków'),
  status:       Position::OPEN,
  posted_date:  '2025-04-20'
)

# Employees
Employee.create!(
  first_name: 'Anna',
  last_name:  'Kowalska',
  email:      'anna.kowalska@company.com',
  hire_date:  '2023-06-01',
  position:   Position.find_by(posted_date: '2025-05-01')
)
Employee.create!(
  first_name: 'Jan',
  last_name:  'Nowak',
  email:      'jan.nowak@company.com',
  hire_date:  '2023-07-10',
  manager:    Employee.find_by(email: 'anna.kowalska@company.com'),
  position:   Position.find_by(posted_date: '2024-02-15')
)
Employee.create!(
  first_name: 'Katarzyna',
  last_name:  'Wiśniewska',
  email:      'kasia.wisniewska@company.com',
  hire_date:  '2024-01-05',
  manager:    Employee.find_by(email: 'anna.kowalska@company.com'),
  position:   Position.find_by(posted_date: '2024-01-10')
)

# Employment Histories
EmploymentHistory.create!(
  employee:   Employee.find_by(email: 'jan.nowak@company.com'),
  position:   Position.find_by(posted_date: '2024-02-15'),
  start_date: '2023-07-10',
  end_date:   nil,
  department: Department.find_by(name: 'Human Resources'),
  manager:    Employee.find_by(email: 'anna.kowalska@company.com')
)
EmploymentHistory.create!(
  employee:   Employee.find_by(email: 'kasia.wisniewska@company.com'),
  position:   Position.find_by(posted_date: '2024-01-10'),
  start_date: '2024-01-05',
  end_date:   nil,
  department: Department.find_by(name: 'IT'),
  manager:    Employee.find_by(email: 'anna.kowalska@company.com')
)

# Compensations
# Compensation.create!(
#   employee:       Employee.find_by(email: 'jan.nowak@company.com'),
#   amount:         5000,
#   currency:       'PLN',
#   effective_date: '2023-07-10',
#   frequency:      'MONTHLY'
# )
# Compensation.create!(
#   employee:       Employee.find_by(email: 'kasia.wisniewska@company.com'),
#   amount:         9000,
#   currency:       'PLN',
#   effective_date: '2024-01-05',
#   frequency:      'MONTHLY'
# )
# Compensation.create!(
#   employee:       Employee.find_by(email: 'anna.kowalska@company.com'),
#   amount:         15000,
#   currency:       'PLN',
#   effective_date: '2023-06-01',
#   frequency:      'MONTHLY'
# )

# Time Off Requests
TimeOffRequest.create!(
  employee:       Employee.find_by(email: 'jan.nowak@company.com'),
  request_type:   'VACATION',
  start_date:     '2025-06-01',
  end_date:       '2025-06-10',
  status:         'APPROVED',
  requested_date: '2025-05-01',
  approved_by:    Employee.find_by(email: 'anna.kowalska@company.com').id,
  approved_date:  '2025-05-05'
)
# TimeOffRequest.create!(
#   employee:       Employee.find_by(email: 'kasia.wisniewska@company.com'),
#   request_type:   'SICK',
#   start_date:     '2025-05-12',
#   end_date:       '2025-05-14',
#   status:         'PENDING',
#   requested_date: '2025-05-10'
# )
