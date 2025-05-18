class PositionController < ApplicationController
    # GET /employees/
    def index
      @positions = Position.all
      render json: @positions
    end
  end