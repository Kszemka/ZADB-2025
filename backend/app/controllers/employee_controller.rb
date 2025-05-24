class EmployeeController < ApplicationController
    # GET employee/all_employees
    def all_employees
      response = Employee.where(is_active: true).all
      render json: response
    end

    # POST employee/hire
    def hire
      response = Employee::EmployeeAddInteractor.run(params)
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

    def inner_join
      render json:Employee.joins(:position)
    end

    def left_join
      employees = Employee.left_joins(:manager)
                    .select('employees.*, managers_employees.first_name AS manager_name')
      render json: employees.as_json(include: [:manager])
    end

    def right_join
      position = Position.joins("RIGHT JOIN employees ON employees.position_id = positions.id")
                         .select('employees.*, positions.job_id AS position_job_id')
      render json: position.as_json
    end

    def full_outer_join
      employees = Employee.joins("FULL OUTER JOIN positions ON employees.position_id = positions.id")
                          .select('employees.*, positions.job_id AS position_job_id')
      render json:employees.as_json
    end

    def cross_join
      employees = Employee.joins("CROSS JOIN departments")
                    .select('employees.*, departments.name AS department_name')
      render json: employees.as_json
    end

end