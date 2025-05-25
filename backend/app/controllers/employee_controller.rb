class EmployeeController < ApplicationController
  # GET employee/all_employees
  def all_employees
    response = Employee.where(is_active: true).all
    render json: response
  end

  # GET employee/search
  def search
    response = Employee::EmployeeSearchInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end

  # GET employee/projects
  def projects
    response = Employee::EmployeeProjectInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end

  # GET employee/history
  def history
    response = Employee::EmployeeHistoryInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end

  # POST employee/hire
  def hire
    response = Employee::EmployeeAddInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end

  # PUT employee/give_raise_for_all
  def give_raise_for_all
    response = Employee::EmployeeRaiseInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end

  # PUT employee/update
  def update
    response = Employee::EmployeeUpdateInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end

  # DELETE employee/delete
  def delete
    interactor = Employee::EmployeeFireInteractor.run(params)
    return render json: interactor, status: :unprocessable_entity unless interactor.valid?

    interactor.delete_hard
    render json: { result: 'Employee hard-deleted' }, status: :ok
  end

  # PATCH employee/delete_soft
  def delete_soft
    interactor = Employee::EmployeeFireInteractor.run(params)
    return render json: interactor, status: :unprocessable_entity unless interactor.valid?

    interactor.delete_soft
    render json: { result: 'Employee soft-deleted' }, status: :ok
  end



  ### join examples
  def inner_join
    render json: Employee.joins(:position)
  end

  def left_join
    employees = Employee.left_joins(:manager)
                        .select('employees.*, managers_employees.first_name AS manager_name')
    render json: employees.as_json(include: [:manager])
  end

  def right_join
    results = ActiveRecord::Base.connection.select_all(
      "SELECT employees.*, positions.job_id AS position_job_id FROM positions RIGHT JOIN employees ON employees.position_id = positions.id"
    )
    render json: results
  end

  def full_outer_join
    results = ActiveRecord::Base.connection.exec_query(<<-SQL)
    SELECT *
    FROM employees
    FULL OUTER JOIN positions ON employees.position_id = positions.id
    SQL

    render json: results.to_a
  end

  def cross_join
    sql = <<-SQL
    SELECT employees.first_name, employees.last_name, projects.name AS project_name
    FROM employees
    CROSS JOIN projects
    LIMIT 100
    SQL

    result = ActiveRecord::Base.connection.exec_query(sql)
    render json: result.to_a
  end

end