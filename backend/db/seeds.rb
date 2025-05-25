ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

# # Departments
# Department.create!(name: 'Head Office')
# Department.create!(name: 'Human Resources', parent_department: Department.find_by(name: 'Head Office'))
# Department.create!(name: 'IT',              parent_department: Department.find_by(name: 'Head Office'))
# Department.create!(name: 'Finance',         parent_department: Department.find_by(name: 'Head Office'))
#
# # Locations
# Location.create!(city: 'Warsaw',   state: 'Mazowieckie',    country: 'Poland')
# Location.create!(city: 'Kraków',   state: 'Małopolskie',    country: 'Poland')
# Location.create!(city: 'London',   state: 'Greater London', country: 'UK')
# Location.create!(city: 'New York', state: 'NY',             country: 'USA')
#
# # Jobs
# Job.create!(code: 'HR_SPEC', title: 'HR Specialist',       min_salary: 4000,  max_salary: 7000)
# Job.create!(code: 'ENG_I',   title: 'Software Engineer I', min_salary: 8000,  max_salary: 12000)
# Job.create!(code: 'FIN_MGR', title: 'Finance Manager',     min_salary: 10000, max_salary: 15000)
#
# # Positions
# Position.create!(
#   job:          Job.find_by(code: 'ENG_I'),
#   department:   Department.find_by(name: 'IT'),
#   location:     Location.find_by(city: 'Warsaw'),
#   status:       Position::OCCUPIED,
#   posted_date:  '2024-01-10'
# )
# Position.create!(
#   job:          Job.find_by(code: 'HR_SPEC'),
#   department:   Department.find_by(name: 'Human Resources'),
#   location:     Location.find_by(city: 'Warsaw'),
#   status:       Position::OCCUPIED,
#   posted_date:  '2024-02-15'
# )
# Position.create!(
#   job:          Job.find_by(code: 'FIN_MGR'),
#   department:   Department.find_by(name: 'Finance'),
#   location:     Location.find_by(city: 'New York'),
#   status:       Position::OCCUPIED,
#   posted_date:  '2025-05-01'
# )
# Position.create!(
#   job:          Job.find_by(code: 'ENG_I'),
#   department:   Department.find_by(name: 'IT'),
#   location:     Location.find_by(city: 'Kraków'),
#   status:       Position::OPEN,
#   posted_date:  '2025-04-20'
# )
#
# # Employees
# Employee.create!(
#   first_name: 'Anna',  last_name: 'Kowalska',
#   email:      'anna@company.com',
#   hire_date:  '2023-06-01',
#   position:   Position.find_by(posted_date: '2025-05-01'),
#   is_active:  true,
#   employment_history: [
#     { position_id: Position.find_by(posted_date: '2025-05-01').id,
#       department_id: Position.find_by(posted_date: '2025-05-01').department_id,
#       manager_id: nil,
#       start_date: '2023-06-01',
#       end_date: nil }
#   ]
# )
#
# Employee.create!(
#   first_name: 'Jan',   last_name: 'Nowak',
#   email:      'jan@company.com',
#   hire_date:  '2023-07-10',
#   position:   Position.find_by(posted_date: '2024-02-15'),
#   manager:    Employee.find_by(email: 'anna@company.com'),
#   is_active:  true,
#   employment_history: [
#     { position_id: Position.find_by(posted_date: '2024-02-15').id,
#       department_id: Position.find_by(posted_date: '2024-02-15').department_id,
#       manager_id: Employee.find_by(email: 'anna@company.com').id,
#       start_date: '2023-07-10',
#       end_date: nil }
#   ]
# )
#
# Employee.create!(
#   first_name: 'Kasia', last_name: 'Wiśniewska',
#   email:      'kasia@company.com',
#   hire_date:  '2024-01-05',
#   position:   Position.find_by(posted_date: '2024-01-10'),
#   manager:    Employee.find_by(email: 'anna@company.com'),
#   is_active:  true,
#   employment_history: [
#     { position_id: Position.find_by(posted_date: '2024-01-10').id,
#       department_id: Position.find_by(posted_date: '2024-01-10').department_id,
#       manager_id: Employee.find_by(email: 'anna@company.com').id,
#       start_date: '2024-01-05',
#       end_date: nil }
#   ]
# )
# # Employment Histories
# EmploymentHistory.create!(
#   employee:   Employee.find_by(email: 'jan@company.com'),
#   position:   Position.find_by(posted_date: '2024-02-15'),
#   start_date: '2023-07-10',
#   end_date:   nil,
#   department: Department.find_by(name: 'Human Resources'),
#   manager:    Employee.find_by(email: 'anna@company.com')
# )
# EmploymentHistory.create!(
#   employee:   Employee.find_by(email: 'kasia@company.com'),
#   position:   Position.find_by(posted_date: '2024-01-10'),
#   start_date: '2024-01-05',
#   end_date:   nil,
#   department: Department.find_by(name: 'IT'),
#   manager:    Employee.find_by(email: 'anna@company.com')
# )
#
# # Compensations
# # Compensation.create!(
# #   employee:       Employee.find_by(email: 'jan.nowak@company.com'),
# #   amount:         5000,
# #   currency:       'PLN',
# #   effective_date: '2023-07-10',
# #   frequency:      'MONTHLY'
# # )
# # Compensation.create!(
# #   employee:       Employee.find_by(email: 'kasia.wisniewska@company.com'),
# #   amount:         9000,
# #   currency:       'PLN',
# #   effective_date: '2024-01-05',
# #   frequency:      'MONTHLY'
# # )
# # Compensation.create!(
# #   employee:       Employee.find_by(email: 'anna.kowalska@company.com'),
# #   amount:         15000,
# #   currency:       'PLN',
# #   effective_date: '2023-06-01',
# #   frequency:      'MONTHLY'
# # )
#
# # Time Off Requests
# TimeOffRequest.create!(
#   employee:       Employee.find_by(email: 'jan@company.com'),
#   request_type:   'VACATION',
#   start_date:     '2025-06-01',
#   end_date:       '2025-06-10',
#   status:         'APPROVED',
#   requested_date: '2025-05-01',
#   approved_by:    Employee.find_by(email: 'anna@company.com').id,
#   approved_date:  '2025-05-05'
# )
# # TimeOffRequest.create!(
# #   employee:       Employee.find_by(email: 'kasia.wisniewska@company.com'),
# #   request_type:   'SICK',
# #   start_date:     '2025-05-12',
# #   end_date:       '2025-05-14',
# #   status:         'PENDING',
# #   requested_date: '2025-05-10'
# # )

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

# DEPARTAMENTY
hq = Department.create!(name: 'Head Office')
hr = Department.create!(name: 'Human Resources', parent_department: hq)
it = Department.create!(name: 'IT', parent_department: hq)
fin = Department.create!(name: 'Finance', parent_department: hq)
sales = Department.create!(name: 'Sales', parent_department: hq)
support = Department.create!(name: 'Support', parent_department: hq)

# LOKALIZACJE
warsaw = Location.create!(city: 'Warsaw', state: 'Mazowieckie', country: 'Poland')
krakow = Location.create!(city: 'Kraków', state: 'Małopolskie', country: 'Poland')
poznan = Location.create!(city: 'Poznań', state: 'Wielkopolskie', country: 'Poland')
wroclaw = Location.create!(city: 'Wrocław', state: 'Dolnośląskie', country: 'Poland')

# STANOWISKA
jobs = [
  Job.create!(code: 'ENG_I', title: 'Software Engineer I', min_salary: 8000, max_salary: 12000),
  Job.create!(code: 'ENG_II', title: 'Software Engineer II', min_salary: 12000, max_salary: 17000),
  Job.create!(code: 'ENG_III', title: 'Senior Software Engineer', min_salary: 16000, max_salary: 22000),
  Job.create!(code: 'QA', title: 'QA Engineer', min_salary: 8000, max_salary: 13000),
  Job.create!(code: 'DEVOPS', title: 'DevOps Engineer', min_salary: 12000, max_salary: 18000),
  Job.create!(code: 'PM', title: 'Project Manager', min_salary: 15000, max_salary: 21000),
  Job.create!(code: 'HR_SPEC', title: 'HR Specialist', min_salary: 6000, max_salary: 9000),
  Job.create!(code: 'SUPPORT', title: 'Support Specialist', min_salary: 5000, max_salary: 9000),
  Job.create!(code: 'FIN_MGR', title: 'Finance Manager', min_salary: 12000, max_salary: 18000),
  Job.create!(code: 'SALES', title: 'Sales Representative', min_salary: 7000, max_salary: 12000)
]

# STANOWISKA (POSITIONS)
positions = []
positions += [
  Position.create!(job: jobs[0], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-01-10'),
  Position.create!(job: jobs[0], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-02-15'),
  Position.create!(job: jobs[0], department: it, location: krakow, status: Position::OCCUPIED, posted_date: '2023-03-01'),
  Position.create!(job: jobs[0], department: it, location: poznan, status: Position::OCCUPIED, posted_date: '2023-04-01'),
  Position.create!(job: jobs[0], department: it, location: wroclaw, status: Position::OCCUPIED, posted_date: '2023-05-01'),
  Position.create!(job: jobs[0], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-06-01'),
  Position.create!(job: jobs[0], department: it, location: krakow, status: Position::OCCUPIED, posted_date: '2023-07-01'),
  Position.create!(job: jobs[0], department: it, location: poznan, status: Position::OCCUPIED, posted_date: '2023-08-01'),
  Position.create!(job: jobs[0], department: it, location: wroclaw, status: Position::OCCUPIED, posted_date: '2023-09-01'),
  Position.create!(job: jobs[0], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-10-01'),

  Position.create!(job: jobs[1], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-11-01'),
  Position.create!(job: jobs[1], department: it, location: krakow, status: Position::OCCUPIED, posted_date: '2023-12-01'),
  Position.create!(job: jobs[1], department: it, location: poznan, status: Position::OCCUPIED, posted_date: '2024-01-01'),
  Position.create!(job: jobs[1], department: it, location: wroclaw, status: Position::OCCUPIED, posted_date: '2024-02-01'),
  Position.create!(job: jobs[1], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2024-03-01'),

  Position.create!(job: jobs[2], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2024-04-01'),
  Position.create!(job: jobs[2], department: it, location: krakow, status: Position::OCCUPIED, posted_date: '2024-05-01'),
  Position.create!(job: jobs[2], department: it, location: poznan, status: Position::OCCUPIED, posted_date: '2024-06-01'),

  Position.create!(job: jobs[3], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2024-07-01'),
  Position.create!(job: jobs[3], department: it, location: krakow, status: Position::OCCUPIED, posted_date: '2024-08-01'),
  Position.create!(job: jobs[3], department: it, location: poznan, status: Position::OCCUPIED, posted_date: '2024-09-01'),

  Position.create!(job: jobs[4], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2024-10-01'),
  Position.create!(job: jobs[4], department: it, location: wroclaw, status: Position::OCCUPIED, posted_date: '2024-11-01'),

  Position.create!(job: jobs[5], department: it, location: warsaw, status: Position::OCCUPIED, posted_date: '2024-12-01'),
  Position.create!(job: jobs[5], department: it, location: krakow, status: Position::OCCUPIED, posted_date: '2025-01-01'),

  Position.create!(job: jobs[6], department: hr, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-01-15'),
  Position.create!(job: jobs[7], department: support, location: poznan, status: Position::OCCUPIED, posted_date: '2023-02-15'),
  Position.create!(job: jobs[7], department: support, location: wroclaw, status: Position::OCCUPIED, posted_date: '2023-03-15'),

  Position.create!(job: jobs[8], department: fin, location: warsaw, status: Position::OCCUPIED, posted_date: '2023-04-15'),
  Position.create!(job: jobs[9], department: sales, location: wroclaw, status: Position::OCCUPIED, posted_date: '2023-05-15')
]

# PRACOWNICY (EMPLOYEES)
employee_data = [
  ['Anna', 'Kowalska', 'anna.kowalska@company.com'],
  ['Jan', 'Nowak', 'jan.nowak@company.com'],
  ['Kasia', 'Wiśniewska', 'kasia.wisniewska@company.com'],
  ['Piotr', 'Zieliński', 'piotr.zielinski@company.com'],
  ['Julia', 'Müller', 'julia.muller@company.com'],
  ['Tomasz', 'Lewandowski', 'tomasz.lewandowski@company.com'],
  ['Agnieszka', 'Dąbrowska', 'agnieszka.dabrowska@company.com'],
  ['Michał', 'Wójcik', 'michal.wojcik@company.com'],
  ['Paweł', 'Krawczyk', 'pawel.krawczyk@company.com'],
  ['Magdalena', 'Kaczmarek', 'magdalena.kaczmarek@company.com'],
  ['Marcin', 'Mazur', 'marcin.mazur@company.com'],
  ['Ewa', 'Krawczyk', 'ewa.krawczyk@company.com'],
  ['Mateusz', 'Piotrowski', 'mateusz.piotrowski@company.com'],
  ['Zofia', 'Grabowska', 'zofia.grabowska@company.com'],
  ['Jakub', 'Pawlak', 'jakub.pawlak@company.com'],
  ['Aleksandra', 'Michalska', 'aleksandra.michalska@company.com'],
  ['Szymon', 'Nowicki', 'szymon.nowicki@company.com'],
  ['Natalia', 'Wróbel', 'natalia.wrobel@company.com'],
  ['Kamil', 'Wieczorek', 'kamil.wieczorek@company.com'],
  ['Marta', 'Zając', 'marta.zajac@company.com'],
  ['Adam', 'Jankowski', 'adam.jankowski@company.com'],
  ['Karolina', 'Kowalczyk', 'karolina.kowalczyk@company.com'],
  ['Grzegorz', 'Szymański', 'grzegorz.szymanski@company.com'],
  ['Patrycja', 'Woźniak', 'patrycja.wozniak@company.com'],
  ['Łukasz', 'Dudek', 'lukasz.dudek@company.com'],
  ['Weronika', 'Baran', 'weronika.baran@company.com'],
  ['Artur', 'Górski', 'artur.gorski@company.com'],
  ['Paulina', 'Król', 'paulina.krol@company.com'],
  ['Sebastian', 'Sikora', 'sebastian.sikora@company.com'],
  ['Dominika', 'Szulc', 'dominika.szulc@company.com']
]

employees = []
employee_data.each_with_index do |(fn, ln, email), i|
  employees << Employee.create!(
    first_name: fn,
    last_name: ln,
    email: email,
    hire_date: (Date.parse("2023-01-01") + i * 10),
    position: positions[i],
    is_active: true
  )
end

# MANAGEROWIE (przypisanie managerów do pracowników)
# Załóżmy, że pierwsze 3 osoby to managerowie
managers = employees.first(3)
employees.each_with_index do |emp, i|
  emp.update(manager: managers[i % 3]) unless managers.include?(emp)
end

# HISTORIA ZATRUDNIENIA (EMPLOYMENT HISTORY)
employees.each do |emp|
  history = EmploymentHistory.create!(
    employee: emp,
    position: emp.position,
    start_date: emp.hire_date,
    end_date: nil,
    department: emp.position.department,
    manager: emp.manager,
  )
  emp.update!(position_history_ids: emp.position_history_ids + [history.id])
end

# WYNAGRODZENIA (COMPENSATIONS)
employees.each do |emp|
  Compensation.create!(
    employee: emp,
    amount: rand(emp.position.job.min_salary..emp.position.job.max_salary),
    currency: 'PLN',
    effective_date: emp.hire_date,
    frequency: 'MONTHLY'
  )
end

projects = [
  Project.create!(name: 'AI Chatbot', code: 'AI001', start_date: '2024-01-01'),
  Project.create!(name: 'CRM Redesign', code: 'CRM002', start_date: '2024-02-15'),
  Project.create!(name: 'Mobile App', code: 'MOB003', start_date: '2024-03-10'),
  Project.create!(name: 'Data Migration', code: 'DATA004', start_date: '2024-04-01'),
  Project.create!(name: 'HR Portal', code: 'HR005', start_date: '2024-05-01')
]

# PRZYPISANIE PRACOWNIKÓW DO PROJEKTÓW
employees.each_with_index do |employee, i|
  projects.sample(2).each do |project|
    employee.projects << project unless employee.projects.include?(project)
  end
end

# Dodajemy kilka otwartych pozycji (bez przypisanego pracownika)
open_positions = [
  Position.create!(
    job: jobs[0], # Software Engineer I
    department: it,
    location: warsaw,
    status: Position::OPEN,
    posted_date: Date.today - 7
  ),
  Position.create!(
    job: jobs[2], # Senior Software Engineer
    department: it,
    location: krakow,
    status: Position::OPEN,
    posted_date: Date.today - 14
  ),
  Position.create!(
    job: jobs[4], # DevOps Engineer
    department: it,
    location: poznan,
    status: Position::OPEN,
    posted_date: Date.today - 3
  ),
  Position.create!(
    job: jobs[7], # Support Specialist
    department: support,
    location: wroclaw,
    status: Position::OPEN,
    posted_date: Date.today - 2
  ),
  Position.create!(
    job: jobs[5], # Project Manager
    department: it,
    location: warsaw,
    status: Position::OPEN,
    posted_date: Date.today - 1
  )
]
