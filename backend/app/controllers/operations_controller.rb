class OperationsController < ApplicationController
  # GET operations/all_departments
  def all_departments
    response = Department.all
    render json: response
  end

  # GET operations/departments_search_by?params
  def departments_search_by
    response = Operations::DepartmentsInteractor.run(params)
    render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
  end


end