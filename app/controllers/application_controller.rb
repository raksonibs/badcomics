class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

<<<<<<< HEAD
  helper_method :current_user

	private

  def getMatchingEvents(dateSent, catListSent, priceSent)
    eventsCat = []
    catListSent.each do |cat| 
      eventsCat << Event.select{|e| e.categoryList.include? cat }
    end
    eventsCat.flatten!

    eventsCatDay = []
    eventsCat.each do |event|
      if event.dayOn != "No start time specified" && event.dayEnd != "No end time specified" && !event.dayEnd.nil? && event.dayEnd.length > 9
        dateRange = (Date.parse(event.dayOn) .. Date.parse(event.dayEnd))
        if Date.parse(event.dayOn) == Date.parse(dateSent)
          eventsCatDay <<  event 
        elsif dateRange.cover?(Date.parse(dateSent))
          eventsCatDay <<  event 
        end
      elsif event.dayOn != "No start time specified" && Date.parse(event.dayOn) == Date.parse(dateSent)
        eventsCatDay <<  event 
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

  def uniqueEvents(eventArray)
    eventsUnique = []
    eventArray.each do |event|
      eventsUnique << event if !eventsUnique.any?{|c| c.name.downcase == event.name.downcase}
    end
    eventsUnique
  end

  def getMatchingDayEvents(dateSent = Date.today, howMany = nil)
    eventsDay = []
    dateSent = Date.try(:parse,dateSent.to_s)
    Event.all.each do |event|
      #  stupid conditions because nil endtime and inapproritate datetime
      if event.dayOn != "No start time specified" && event.dayEnd != "No end time specified" && !event.dayEnd.nil? && event.dayEnd.length > 9
        dateRange = (Date.parse(event.dayOn) .. Date.parse(event.dayEnd))
        if Date.parse(event.dayOn) == dateSent
          eventsDay <<  event 
        elsif dateRange.cover?(dateSent)
          eventsDay <<  event 
        end
      elsif event.dayOn != "No start time specified" && Date.parse(event.dayOn) == dateSent
        eventsDay <<  event 
      end

      return eventsDay if howMany != nil && eventsDay.count == howMany
    end
    eventsDay
  end

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
=======
  # before_filter :require_login

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
end
