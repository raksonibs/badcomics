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
#need to worry aout if events have sold tickets
class WelcomeController < ApplicationController
  def index
  	@data=cityhall
  end

  def home
  end


  def getdata
  	"[cityhall,
  	nowmagazine not working,
  	eventbrite working,
  	justshows -need to fix all ages advance door part, maybe only grab price?
  	]"
  	#parks,
  	#eventful,
  	#clubcrawlers,
  	#xlsattraction,
  	#facebook
  	#meetup
  end

  def cityhall
  	info={}
  	date=Date.today#.strftime("%B %01d, %Y")
  	data=Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
  	countend=data.size
  	count=0
  	#might not need time end? maybe will have to
  	#info[name]=date start, time start, date end, time end, price, address, category
  	#should only get events with current date, not all dates
  	#.text method on xpath?
  	
  	
  	

  	data.each do |val|
  		range = Date.parse(val.xpath("//entrydata[@name='DateBeginShow']")[count].text) .. Date.parse(val.xpath("//entrydata[@name='DateEndShow']")[count].text)
  		if range.include?(date)
  			info[val.xpath("//entrydata[@name='EventName']")[count].text]=[val.xpath("//entrydata[@name='DateBeginShow']")[count].text,
  																  	val.xpath("//entrydata[@name='TimeBegin']")[count].text, 
  																  	val.xpath("//entrydata[@name='DateEndShow']")[count].text, 
  																 	 val.xpath("//entrydata[@name='TimeEnd']")[count].text,
  																  	val.xpath("//entrydata[@name='Admission']")[count].text,
  																  	val.xpath("//entrydata[@name='Location']")[count].text,
  																 	val.xpath("//entrydata[@name='CategoryList']")[count]] unless val==nil
  		end
  		count+=1
  	end

  		#count+=1
  	#end
  	#date===range
  	info
  	#December 4, 2013
  end

  def nowmagazine
  	#trouble with getting the values out to get the date
  	info={}
  	date=DateTime.now
  	data=Nokogiri::HTML(open("http://www.nowtoronto.com/news/listings/"))
  	.css(".listing-entry")[0].css("div.day#{date.day}month#{date.month}")
  	data.css("div.day#{date.day}month#{date.month}")
  	#data.each do |val|
  		#info[val.css("")]
  	#need to categorize event

  end

  def xlsattraction
  	#need to make list of things. i guess snakes and lattes and other things
  	# we curate can be in here. blog to entries added to this list?
  	#feeling touristry
  end

  def eventbrite
  	info={}
  	#name=time (need to extract time), tickets[price], address NEED CATEGORY TO ATTRBIUTE
  	data=JSON.parse((open("http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=today&max=100")).read)
  	data=data["events"]
  	data[1..100].each do |event|
		info[event["event"]["title"]]=[event["event"]["start_date"],event["event"]["tickets"][0]["ticket"]["price"],event["event"]["venue"]["address"]]
	end
	info
  	#data.each do |val|
  		#info[val["event"]["title"]]=[]
  	#end

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
  	#all events=even=Nokogiri::HTML(open("http://justshows.com/toronto/")).css("ul.shows li")
  	#time, price, location, #NEED CATEGORY - ALL WIL BE MUSIC HERE?
  	#might be problem if performers are playing twice on different days
  	info1={}
  	date=Date.today.strftime("%a")+" "+ Date.today.strftime("%B")[0..2]+" " + Date.today.strftime("%01d")

  	data=Nokogiri::HTML(open("http://justshows.com/toronto/")).css("ul.shows li")
  	data[0..1].each do |val| 
  		p date
  		p val.css("strong.day").text
  		if date == val.css("strong.day").text
  			p val.css("title").text
  			p val.css("span.time").text 
  			p val.css("strong.location").text
  			p val.css("span.venue-meta br")[0].text
  			info1[val.css("strong.summary").text]=[val.css("span.time").text, 
  													val.css("strong.location").text, 
  													(val.css("span.venue-meta").text)]
  		end
  	end
  	info1
  	
  	
  	# strong class day spanl class time -> get all events that 
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
