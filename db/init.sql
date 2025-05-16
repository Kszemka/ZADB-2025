-- 1. DEPARTMENT
CREATE TABLE department (
  department_id      SERIAL PRIMARY KEY,
  name               VARCHAR(100) NOT NULL,
  parent_department  INTEGER REFERENCES department(department_id)
);

-- 2. LOCATION
CREATE TABLE location (
  location_id  SERIAL PRIMARY KEY,
  city         VARCHAR(50),
  state        VARCHAR(50),
  country      VARCHAR(50)
);

-- 3. JOB
CREATE TABLE job (
  job_id     SERIAL PRIMARY KEY,
  code       VARCHAR(20) UNIQUE NOT NULL,
  title      VARCHAR(100) NOT NULL,
  min_salary NUMERIC(10,2),
  max_salary NUMERIC(10,2)
);

-- 4. POSITION
CREATE TABLE position (
  position_id   SERIAL PRIMARY KEY,
  job_id        INTEGER NOT NULL REFERENCES job(job_id),
  department_id INTEGER NOT NULL REFERENCES department(department_id),
  location_id   INTEGER NOT NULL REFERENCES location(location_id),
  status        VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  posted_date   DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 5. EMPLOYEE
CREATE TABLE employee (
  employee_id   SERIAL PRIMARY KEY,
  first_name    VARCHAR(50) NOT NULL,
  last_name     VARCHAR(50) NOT NULL,
  email         VARCHAR(100) UNIQUE NOT NULL,
  hire_date     DATE NOT NULL,
  manager_id    INTEGER REFERENCES employee(employee_id),
  department_id INTEGER REFERENCES department(department_id),
  position_id   INTEGER REFERENCES position(position_id)
);

-- 6. EMPLOYMENT_HISTORY
CREATE TABLE employment_history (
  history_id     SERIAL PRIMARY KEY,
  employee_id    INTEGER NOT NULL REFERENCES employee(employee_id),
  position_id    INTEGER NOT NULL REFERENCES position(position_id),
  start_date     DATE NOT NULL,
  end_date       DATE,
  department_id  INTEGER NOT NULL REFERENCES department(department_id),
  manager_id     INTEGER REFERENCES employee(employee_id)
);

-- 7. COMPENSATION
CREATE TABLE compensation (
  comp_id        SERIAL PRIMARY KEY,
  employee_id    INTEGER NOT NULL REFERENCES employee(employee_id),
  amount         NUMERIC(12,2) NOT NULL,
  currency       CHAR(3)        NOT NULL DEFAULT 'PLN',
  effective_date DATE           NOT NULL,
  frequency      VARCHAR(20)    NOT NULL DEFAULT 'MONTHLY'
);

-- 8. TIME_OFF_REQUEST
CREATE TABLE time_off_request (
  request_id     SERIAL PRIMARY KEY,
  employee_id    INTEGER NOT NULL REFERENCES employee(employee_id),
  type           VARCHAR(20)    NOT NULL,
  start_date     DATE           NOT NULL,
  end_date       DATE           NOT NULL,
  status         VARCHAR(20)    NOT NULL DEFAULT 'PENDING',
  requested_date DATE           NOT NULL DEFAULT CURRENT_DATE,
  approved_by    INTEGER        REFERENCES employee(employee_id),
  approved_date  DATE
);

-- opcjonalnie: indeksy pomocnicze
CREATE INDEX ON employee(department_id);
CREATE INDEX ON position(status);
CREATE INDEX ON compensation(effective_date);
CREATE INDEX ON time_off_request(status);


------ UZUPEŁNIANIE DUMMY WARTOŚCI --------
-- 1. Departments
INSERT INTO department (department_id, name, parent_department) VALUES
  (1, 'Head Office', NULL),
  (2, 'Human Resources', 1),
  (3, 'IT', 1),
  (4, 'Finance', 1);

-- 2. Locations
INSERT INTO location (location_id, city, state, country) VALUES
  (1, 'Warsaw',   'Mazowieckie', 'Poland'),
  (2, 'Kraków',   'Małopolskie', 'Poland'),
  (3, 'London',   'Greater London', 'UK'),
  (4, 'New York', 'NY', 'USA');

-- 3. Jobs
INSERT INTO job (job_id, code, title, min_salary, max_salary) VALUES
  (1, 'HR_SPEC', 'HR Specialist', 4000.00, 7000.00),
  (2, 'ENG_I',   'Software Engineer I', 8000.00, 12000.00),
  (3, 'FIN_MGR','Finance Manager', 10000.00,15000.00);

-- 4. Positions
INSERT INTO position (position_id, job_id, department_id, location_id, status, posted_date) VALUES
  (1, 2, 3, 1, 'FILLED',   '2024-01-10'),
  (2, 1, 2, 1, 'FILLED',   '2024-02-15'),
  (3, 3, 4, 4, 'OPEN',     '2025-05-01'),
  (4, 2, 3, 2, 'OPEN',     '2025-04-20');

-- 5. Employees
INSERT INTO employee (employee_id, first_name, last_name, email, hire_date, manager_id, department_id, position_id) VALUES
  (1, 'Anna',   'Kowalska', 'anna.kowalska@company.com', '2023-06-01', NULL, 1,  NULL),-- CEO
  (2, 'Jan',    'Nowak',    'jan.nowak@company.com',    '2023-07-10', 1, 2, 2),    -- HR Specialist, manager=Anna
  (3, 'Katarzyna','Wiśniewska','kasia.wisniewska@company.com','2024-01-05', 1, 3, 1),     -- Eng I, manager=Anna
  (4, 'Robert', 'Lewandowski','robert.lewandowski@company.com','2025-03-20', 3, 3, NULL); -- junior eng (still OPEN)

-- 6. Employment History
INSERT INTO employment_history (history_id, employee_id, position_id, start_date, end_date, department_id, manager_id) VALUES
  (1, 2, 2, '2023-07-10', NULL, 2, 1),
  (2, 3, 1, '2024-01-05', NULL, 3, 1);

-- 7. Compensation
INSERT INTO compensation (comp_id, employee_id, amount, currency, effective_date, frequency) VALUES
  (1, 2, 5000.00, 'PLN', '2023-07-10', 'MONTHLY'),
  (2, 3, 9000.00, 'PLN', '2024-01-05', 'MONTHLY'),
  (3, 1,15000.00,'PLN','2023-06-01','MONTHLY');

-- 8. Time Off Requests
INSERT INTO time_off_request (request_id, employee_id, type, start_date, end_date, status, requested_date, approved_by, approved_date) VALUES
  (1, 2, 'VACATION', '2025-06-01', '2025-06-10','APPROVED','2025-05-01',1,'2025-05-05'),
  (2, 3, 'SICK',     '2025-05-12', '2025-05-14','PENDING', '2025-05-10',NULL,NULL),
  (3, 4, 'VACATION', '2025-07-20', '2025-07-25','PENDING', '2025-05-15',NULL,NULL);
