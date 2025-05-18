departments = Department.create!([
  { id: 1, name: 'Head Office',      parent_department_id: nil },
  { id: 2, name: 'Human Resources',  parent_department_id: 1 },
  { id: 3, name: 'IT',               parent_department_id: 1 },
  { id: 4, name: 'Finance',          parent_department_id: 1 }
])

locations = Location.create!([
  { id: 1, city: 'Warsaw',   state: 'Mazowieckie',    country: 'Poland' },
  { id: 2, city: 'Kraków',   state: 'Małopolskie',    country: 'Poland' },
  { id: 3, city: 'London',   state: 'Greater London', country: 'UK' },
  { id: 4, city: 'New York', state: 'NY',             country: 'USA' }
])

jobs = Job.create!([
  { id: 1, code: 'HR_SPEC', title: 'HR Specialist',        min_salary: 4000, max_salary: 7000 },
  { id: 2, code: 'ENG_I',   title: 'Software Engineer I',  min_salary: 8000, max_salary: 12000 },
  { id: 3, code: 'FIN_MGR', title: 'Finance Manager',      min_salary: 10000, max_salary: 15000 }
])

positions = Position.create!([
  { id: 1, job: jobs[1], department: departments[2], location: locations[0], status: 'FILLED', posted_date: '2024-01-10' },
  { id: 2, job: jobs[0], department: departments[1], location: locations[0], status: 'FILLED', posted_date: '2024-02-15' },
  { id: 3, job: jobs[2], department: departments[3], location: locations[3], status: 'OPEN',   posted_date: '2025-05-01' },
  { id: 4, job: jobs[1], department: departments[2], location: locations[1], status: 'OPEN',   posted_date: '2025-04-20' }
])

employees = Employee.create!([
  { id: 1, first_name: 'Anna',      last_name: 'Kowalska',     email: 'anna.kowalska@company.com', hire_date: '2023-06-01', manager_id: nil, department: departments[0], position: positions[2] },
  { id: 2, first_name: 'Jan',       last_name: 'Nowak',        email: 'jan.nowak@company.com',    hire_date: '2023-07-10', manager_id: employees&.find { |e| e.id == 1 }, department: departments[1], position: positions[1] },
  { id: 3, first_name: 'Katarzyna', last_name: 'Wiśniewska',  email: 'kasia.wisniewska@company.com', hire_date: '2024-01-05', manager_id: employees&.find { |e| e.id == 1 }, department: departments[2], position: positions[0] }
])

EmploymentHistory.create!([
  { employee: employees[1], position: positions[1], start_date: '2023-07-10', end_date: nil, department: departments[1], manager: employees[0] },
  { employee: employees[2], position: positions[0], start_date: '2024-01-05', end_date: nil, department: departments[2], manager: employees[0] }
])

Compensation.create!([
  { employee: employees[1], amount: 5000,  currency: 'PLN', effective_date: '2023-07-10', frequency: 'MONTHLY' },
  { employee: employees[2], amount: 9000,  currency: 'PLN', effective_date: '2024-01-05', frequency: 'MONTHLY' },
  { employee: employees[0], amount: 15000, currency: 'PLN', effective_date: '2023-06-01', frequency: 'MONTHLY' }
])

TimeOffRequest.create!([
  { employee: employees[1], request_type: 'VACATION', start_date: '2025-06-01', end_date: '2025-06-10', status: 'APPROVED', requested_date: '2025-05-01', approved_by: employees[0].id, approved_date: '2025-05-05' },
  { employee: employees[2], request_type: 'SICK',     start_date: '2025-05-12', end_date: '2025-05-14', status: 'PENDING',  requested_date: '2025-05-10' },
])
