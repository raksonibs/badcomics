class API::V1::EventsController < ApplicationController
  helper_method :getMatchingEvents
  helper_method :getMatchingDayEvents
  helper_method :uniqueEvents

  respond_to :json

  def index
    @events = Event.all
    respond_with @events
  end

  def today
    @eventsToday = uniqueEvents(getMatchingDayEvents)
    respond_with @eventsToday
  end
end
