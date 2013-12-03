require 'open-uri'
require 'nokogiri'
#www.toronto.come seems to get data from cityhall
#need to convert attractions list to data
#problem with direct html scrapping is if they change their website. will have to deal with
#errors if they come and say that if doesnt load probaly, doesnt submit to user (pick somethin
	#else. then we get notifcation of errors)
#might be better to only get the certain data once they pick their moods and money?

#want to make smart databased on location, price, event, category wiht multiple tags-need name price, location, categories
#tags based on 12 options right now. Will have to match based on description or title
#need to remove location
class WelcomeController < ApplicationController
  def index
  	@data=nowmagazine
  end

  def home
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
  	info={}
  	data=Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
  	countend=data.size
  	count=0
  	#info[name]=date start, time start, date end, time end, price, address, category
  	#should only get events with current date, not all dates
  	data.each do |val|
  		info[val.xpath("//entrydata[@name='EventName']")[count]]=[val.xpath("//entrydata[@name='DateBeginShow']")[count],
  																  val.xpath("//entrydata[@name='TimeBegin']")[count], 
  																  val.xpath("//entrydata[@name='DateEndShow']")[count], 
  																  val.xpath("//entrydata[@name='TimeEnd']")[count],
  																  val.xpath("//entrydata[@name='Admission']")[count],
  																  val.xpath("//entrydata[@name='Location']")[count],
  																  val.xpath("//entrydata[@name='CategoryList']")[count]] unless val==nil
  		count+=1
  	end
  	info
  end

  def nowmagazine
  	info={}
  	date=Date.today
  	data=Nokogiri::HTML(open("http://www.nowtoronto.com/news/listings/"))
  	.css(".listing-entry")[0]
  	
  	#data.each do |val|
  		#info[val.css("")]
  	#need to categorize event

  end

  def xlsattraction

  end

  def eventbrite
  	JSON.parse((open("http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=today&max=100")).read)
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
  	#facebook api graph
  end

  def unqiuefinds
  	#snakes and latees
  end

  def getIP
  end

  def meetup
  	#&lat=43.7&lon=79.4
	JSON.parse(open("https://api.meetup.com/2/open_events?status=upcoming&radius=25.0&city=Toronto&format=json&lat=43.7&lon=79.4&sig_id=122316042&sig=abfea66017a637350ba99380aecfb8e48811436f&key=7b794c3657477db4e107a7e366f7b5f").read)  	 	
  end


end
