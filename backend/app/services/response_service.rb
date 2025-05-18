class ResponseService < ActiveInteraction::Base
  def as_json(*)
    if valid?
      { result: result }
    else
      { errors: errors.full_messages }
    end
  end

  def to_json(*args)
    as_json.to_json(*args)
  end
end