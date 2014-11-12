require 'open-uri'
require 'active_support/core_ext/numeric/time'

class WelcomeController < ApplicationController
  before_action :get_ip, only: [:matchEvents]

  def matchEvents(date=nil,activity=nil, money=nil)
    # going to list match that day, activity, and price range
    # then all events on that date
    # then can quickly change on that page in side bar
  	coords = get_ip
  	date, activity, money = params[:choice1], params[:choice2], params[:choice3]
  	timenow = Time.now

  	if money[/-/]
			money = money[/-\$\d+/][2..money.length]
		elsif money[/\d+/]
			money = money[/\$\d+/][1..money.length]
		else
			money = 0
		end

	  activity = activityMap(activity)
    @data = getposs(activity,feelingmap,money, timenow)

    respondpage(@data,udist,activity,feeling,feelingmap, params, recommend)
  end

  def activityMap(activity)

  end

  private
  def get_ip
    [request.location.latitude, request.location.longitude]
  end
end

