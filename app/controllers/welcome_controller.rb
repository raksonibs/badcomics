require 'open-uri'
require 'nokogiri'
#www.toronto.come seems to get data from cityhall
#need to convert attractions list to data
#problem with direct html scrapping is if they change their website. will have to deal with
#errors if they come and say that if doesnt load probaly, doesnt submit to user (pick somethin
	#else. then we get notifcation of errors)
#might be better to only get the certain data once they pick their moods and money?
class WelcomeController < ApplicationController
  def index
  	@data=clubcrawlers
  end


  def getdata
  	"[cityhall,
  	nowmagazine,
  	xlsattraction,
  	eventbrite,
  	parks,
  	eventful,
  	clubcrawlers,
  	justshows]"
  end

  def cityhall
  	Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
  	#need to categorize data by music event etc
  end

  def nowmagazine
  	Nokogiri::HTML(open("http://www.nowtoronto.com/news/listings/"))
  	.css(".listing-entry")
  	#need to categorize event

  end

  def xlsattraction

  end

  def eventbrite
  	JSON.parse((open("https://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=today&max=100")).read)
  	#<% @data["events"][1..100].each do |event|%>
	#<%= event["event"]["title"] %><br>
#<% end %>
#need to categorize
  end
  	
  def parks
  	
  end

  def eventful
  	JSON.parse((open("http://api.eventful.com/json/events/search?app_key=hSXmLwVD99qfGPBs&location=Toronto&t=today&page_size=200")).read)
  	#same technique in eventbrite
  end

  def clubcrawlers
  	even=Nokogiri::HTML(open("http://www.clubcrawlers.com/toronto/nightclubs/allvenues?crowd=&sort=p#listings")).css(".club-block")
  	odd=Nokogiri::HTML(open("http://www.clubcrawlers.com/toronto/nightclubs/allvenues?crowd=&sort=p#listings")).css(".club-block.odd")
  	even+odd
  end

  def justshows
  	even=Nokogiri::HTML(open("http://justshows.com/toronto/")).css("ul.shows li")
  end

  def movies
  end

  def localfacebookevents
  end

  def unqiuefinds
  	#snakes and latees
  end

  def getIP
  end

  
end
