require 'open-uri'
require 'active_support/core_ext/numeric/time'

class WelcomeController < ApplicationController
  # before_action :get_ip, only: [:matchEvents]

  def matchEvents(date=Date.today,activity=nil, money=nil)
    # going to list match that day, activity, and price range
    # then all events on that date
    # then can quickly change on that page in side bar
    # 12-11-2014 Joke, Laugh, Cry, free
  	date, activity, money = params[:choice1], params[:choice2], params[:choice3]
  	timenow = Time.now

  	if money[/-/]
			money = money[/-\$\d+/][2..money.length].to_i
		elsif money[/\d+/]
			money = money[/\$\d+/][1..money.length].to_i
		else
			money = 0
		end

	  activityMappedInterests = activityMapInterests(activity)

    @matchedEvents = getMatchingEvents(date, activityMappedInterests, money)
    binding.pry

    respond_to do |format|
      format.js{ render :action => "/all.js.erb" }
    end
    # Note: must subtract above from result of getDay events
    # @sameDayEvents = getDayEvents(date) - @matchedEvents

    # respondpage(@data,udist,activity,feeling,feelingmap, params, recommend)
  end

  def getMatchingEvents(dateSent, catListSent, priceSent)
    eventsCat = []
    catListSent.each do |cat| 
      eventsCat << Event.select{|e| e.categoryList.include? cat }
    end
    eventsCat.flatten!
    # also need to check if dates are inbetween!
    # also time could not be specified
    eventsCatDay = []
    eventsCat.each do |event|
      if event.dayOn != "No start time specified"
        dateRange = (Date.parse(e.dayOn) .. Date.parse(e.dayEnd))
        if Date.parse(e.dayOn) == Date.parse(dateSent)
          eventsCatDay <<  event 
        elsif dateRange.cover?(Date.parse(dateSent))
          eventsCatDay <<  event 
        end
          
      end
    end 

    eventsCatDayPrice = []
    eventsCatDay.each do |event|
      price  = event.price
      price = 0 if price == "Free"
      # currently making check lisitng url very expensive because difficult
      price = 300 if price == "Check listing url!"
      eventsCatDayPrice << event if price.to_i <= priceSent
    end
    eventsCatDayPrice
  end

  def activityMapInterests(activitySelected)
    activityInterests = []
    activityInterests << ["Music", 'Jazz', 'Classical', 'Experimental', 'Country', 'World', 'Pop', 'Rock', 'Hip-Hop'] if activitySelected == "Jam Out"
    activityInterests << ['Seminars', 'Workshops', 'History', 'Books', 'Learn', 'Art', 'Exhibits', 'Cultural'] if activitySelected == "Expand Mind"
    activityInterests << ['Seminars', 'Workshops', 'History', 'Books', 'Geek'] if activitySelected == "Geek Out"
    activityInterests << ['Misc', 'Queer'] if activitySelected == "Try New Things"
    activityInterests << ['Seasonal', 'Season', 'Festive', 'Holiday'] if activitySelected == "Be Merry"
    activityInterests << ['Comedy', 'Laugh'] if activitySelected == "Joke, Laugh, Cry"
    activityInterests << ['Celebrations', 'Farmers markets', 'Exhibits', 'Festivals'] if activitySelected == "Be a Tourist"
    activityInterests << ['Charity', 'Cause', 'Benefits', 'Good', 'Community'] if activitySelected == "Be a Good Person"
    activityInterests << ['DJ', 'Celebrations', 'Party', 'Dance', 'Lounge'] if activitySelected == "Party Hardy"
    activityInterests << ['Fitness', 'Sport', 'Dance', 'Hiking'] if activitySelected == "Sports, sport"
    activityInterests << ['Film', 'Comedy', 'Stage', 'Live performances', 'Watch'] if activitySelected == "Watch a Show"
    activityInterests << ['Walking', 'Hiking', 'Outdoor'] if activitySelected == "Trek Outdoors"
    activityInterests << ['Food', 'Benefits'] if activitySelected == "Foody Cravings"
    activityInterests << ['Religion'] if activitySelected == "Divine Revelation"
    activityInterests << ['Investing', 'Consumer shows', 'Seminars', 'Workshops'] if activitySelected == "All Business"
    activityInterests << ['Arts', 'Exhibits', 'Stage', 'Theatre', 'Cultural', 'Cultured', 'Art'] if activitySelected == "Get Cultured"
    activityInterests << ['Family', 'Children', 'Charity', 'All'] if activitySelected == "Family Channel"
    activityInterests << ['Art', 'Arts', 'Exihibts', 'Cultured'] if activitySelected == "Artsy Fartsy"
    activityInterests << ['Film', 'Theatre', 'Stage', 'Watch'] if activitySelected == "A Day at the Theatre"
    activityInterests.flatten!
  end

  private
  def get_ip
    coords = [request.location.latitude, request.location.longitude]
  end
end

