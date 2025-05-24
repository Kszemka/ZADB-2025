class PositionController < ApplicationController
    # GET /position/all
    def all
      response = Position.all
      render json: response
    end

    # GET /position/search_by?params
    def search_by
      response = Operations::PositionSearchInteractor.run(params)
      render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
    end

    # POST /position/create
    def create
      response = Operations::PositionCreateInteractor.run(params)
      render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
    end

    # PUT /position/update
    def update
      response = Operations::PositionInteractor.run(params)
      render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
    end

    # DELETE /position/delete
    def delete
      response = Operations::PositionInteractor.run(params)
      render json: response, status: (response.valid? ? :ok : :unprocessable_entity)
    end

    # GET /position/withDetails
    def withDetails
      positions = Position.includes(:job, :department).all
      render json: positions.as_json(include: [:job, :department])
    end

  end