class API::V1::EventsController < ApplicationController
  helper_method :getMatchingEvents
  helper_method :getMatchingDayEvents
  helper_method :uniqueEvents

  before_filter :restrict_access

  respond_to :json

  # http_basic_authenticate_with name: Figaro.env.api_name, password: Figaro.env.api_password

  def index
    @events = Event.all
    respond_with @events
  end

  def today
    @eventsToday = uniqueEvents(getMatchingDayEvents)
    respond_with @eventsToday
  end

  private

  def restrict_access
    api_key = APIKey.find_by_access_token(params[:access_token])
    expired = api_key != nil && Date.today < Date.parse(api_key.expires_on)
    head :unauthorized unless api_key && expired
  end

  # def restrict_access
  #   authenticate_or_request_with_http_token do |token, options|
  #   ApiKey.exists?(access_token: token)
  # end
end
