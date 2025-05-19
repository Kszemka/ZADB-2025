class PositionController < ApplicationController
    # GET /position/all
    def all
      @positions = Position.all
      render json: @positions
    end

    # GET /position/withDetails
    def withDetails
      positions = Position.includes(:job, :department).all
      render json: positions.as_json(include: [:job, :department])
    end

  end