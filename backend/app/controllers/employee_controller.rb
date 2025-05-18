class EmployeeController < ApplicationController
    # GET /all_employees
    def all_employees
      @employees = Employee.all
      render json: @employees
    end

    def hire
      render json: "OK"
    end  
end