class API::EventsController < ApplicationController
  def index
    @events = Event.all
    respond_to do |format|
      format.json { render json: @events}
    end
  end

  def calculate_score(feeling, activity, price)
  end

  def calculate_distance(location)
  end

  def days_events(day)
  end
end