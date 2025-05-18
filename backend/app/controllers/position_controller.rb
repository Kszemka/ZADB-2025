class PositionController < ApplicationController
    # GET /position/all
    def all
      @positions = Position.all
      render json: @positions
    end
  end