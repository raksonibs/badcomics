require 'open-uri'
require 'active_support/core_ext/numeric/time'

class WelcomeController < ApplicationController
  # before_action :get_ip, only: [:matchEvents]
  before_action :get_categories, only: [:matchEvents, :home]
  before_action :get_prices, only: [:matchEvents, :home]
  before_action :getFriends, only: :index

  def home
  end

  def index
    if current_user
      user = FbGraph::User.new(current_user.uid, access_token: current_user.oauth_token)
      @picture = user.picture
      @daysEvents = getMatchingDayEvents(Date.today.to_s, 3).shuffle!
    end
  end

  def matchEvents(date = Date.today, activity = nil, money = nil)
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

    @matchedEvents = uniqueEvents(getMatchingEvents(date, activityMappedInterests, money)).shuffle!
    @matchedDayEvents = uniqueEvents(getMatchingDayEvents(date) - @matchedEvents).shuffle!

    respond_to do |format|
      format.js{ render :action => "/all.js.erb" }
    end
  end

  def getMatchingDayEvents(dateSent = Date.today, howMany = nil)
    eventsDay = []
    Event.all.each do |event|
      #  stupid conditions because nil endtime and inapproritate datetime
      if event.dayOn != "No start time specified" && event.dayEnd != "No end time specified" && !event.dayEnd.nil? && event.dayEnd.length > 9
        dateRange = (Date.parse(event.dayOn) .. Date.parse(event.dayEnd))
        if Date.parse(event.dayOn) == Date.parse(dateSent)
          eventsDay <<  event 
        elsif dateRange.cover?(Date.parse(dateSent))
          eventsDay <<  event 
        end
      elsif event.dayOn != "No start time specified" && Date.parse(event.dayOn) == Date.parse(dateSent)
        eventsDay <<  event 
      end

      return eventsDay if howMany != nil && eventsDay.count == howMany
    end
    eventsDay
  end

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

  def activityMapInterests(activitySelected)
    activityInterests = []
    activityInterests << ["Music", 'Jazz', 'Classical', 'Experimental', 'Country', 'World', 'Pop', 'Rock', 'Hip-Hop'] if activitySelected == "Jam Out"
    activityInterests << ['Seminars', 'Workshops', 'History', 'Books', 'Learn', 'Art', 'Exhibits', 'Cultural'] if activitySelected == "Expand Mind"
    activityInterests << ['Seminars', 'Workshops', 'History', 'Books', 'Geek'] if activitySelected == "Geek Out"
    activityInterests << ['Misc', 'Queer'] if activitySelected == "Try New Things"
    activityInterests << ['Misc', 'Experimental', "Hip-Hop", 'Hiking', 'Benefits'] if activitySelected == "Meet New People"
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
    activityInterests << ['Film', 'Theatre', 'Stage', 'Watch'] if activitySelected == "Where Art Thou"
    activityInterests.flatten!
  end

  private

  def get_categories
    @categories = ["Get Cultured", "Expand Mind", "Try New Things", 
                  "Be Merry", "Meet New People", "Joke, Laugh, Cry", 
                  "Be a Tourist", "Jam Out", "Be a Good Person", 
                  "Party Hardy", "Family Channel", "Sports, sport", 
                  "Watch a Show", "Trek Outdoors", "Foody Cravings", 
                  "Divine Revelation", "All Business", "Artsy Fartsy", 
                  "Where Art Thou", "Geek Out"]
  end

  def get_prices
    @prices = ["Free", "<$20", "$20-$40",
                "$40-$80", "$80-$160", "I don't care!"]
  end

  def uniqueEvents(eventArray)
    eventsUnique = []
    eventArray.each do |event|
      eventsUnique << event if !eventsUnique.any?{|c| c.name.downcase == event.name.downcase}
    end
    eventsUnique
  end

  def uniqueLeven(eventsArray)
    # this recursive running with double loop is too slow. 
    largeDistanceEvents = []
    eventsArray.each do |event|
      eventsArray.each do |secondEvent|
        largeDistanceEvents << secondEvent if levenshtein(event.name, secondEvent.name) > 3
      end
    end
    largeDistanceEvents
  end

  def levenshtein(first, second)
    # comparing each string with the other is difficult to do. Especially comparing every created string with every next string. that is o(n)  +matrix traversal. On the smaller list slightly faster.
    first = first.downcase
    second = second.downcase
    matrix = [(0..first.length).to_a]
    (1..second.length).each do |j|
      matrix << [j] + [0] * (first.length)
    end
   
    (1..second.length).each do |i|
      (1..first.length).each do |j|
        if first[j-1] == second[i-1]
          matrix[i][j] = matrix[i-1][j-1]
        else
          matrix[i][j] = [
            matrix[i-1][j],
            matrix[i][j-1],
            matrix[i-1][j-1],
          ].min + 1
        end
      end
    end
    return matrix.last.last
  end

  def getFriends
    if current_user
      @installed = JSON.parse(open("https://graph.facebook.com/#{current_user.uid}/friends?access_token=#{current_user.oauth_token}&fields=installed").read)['data']
      @friends = {}
      @installed.each do |friend|
        if friend["installed"]
          @friends[FbGraph::User.fetch(friend["id"])] = friend["id"]
        end
      end
    end
  end

  def get_ip
    coords = [request.location.latitude, request.location.longitude]
  end
end

