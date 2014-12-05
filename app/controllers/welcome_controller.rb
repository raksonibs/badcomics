require 'open-uri'
require 'active_support/core_ext/numeric/time'

class WelcomeController < ApplicationController
  # before_action :get_ip, only: [:matchEvents]
  before_action :get_categories, only: [:matchEvents, :home]
  before_action :get_prices, only: [:matchEvents, :home]
  before_action :getFriends, only: :index
  helper_method :getMatchingEvents
  helper_method :getMatchingDayEvents
  helper_method :uniqueEvents

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

  def getFriends
    if current_user
      @installed = JSON.parse(open("https://graph.facebook.com/#{current_user.uid}/friends?access_token=#{current_user.oauth_token}&fields=installed").read)['data']
      @friends = {}
      @installed.each do |friend|
        @friends[FbGraph::User.fetch(friend["id"])] = friend["id"] if friend["installed"]
      end
    end
  end

  def get_ip
    coords = [request.location.latitude, request.location.longitude]
  end
end

