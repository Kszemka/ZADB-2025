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
      render json:Employee.left_joins(:manager)
                          .select('employees.*, managers_employees.first_name AS manager_name')
    end

    def right_join
      render json:Position.joins("RIGHT JOIN employees ON employees.position_id = positions.id")
    end

    def full_outer_join
      render json:Employee.joins("FULL OUTER JOIN positions ON employees.position_id = positions.id")
    end

    def cross_join
      render json:Employee.joins("CROSS JOIN departments")
    end

end