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
#need to normalize for each
#need basic general categories, also find keywords for them?
#attractions for touristy
#also want like facebook friend parties
#also funny things like sleep? maybe shouldnt tell them what to do lol
#tag based on season
class WelcomeController < ApplicationController
  def index
  	@data=meetup
  end

  def test
  	@data=getdata
  end

  def home
  end


  def getdata
  	[cityhall,
  	nowmagazine,
  	eventbrite,
  	justshows,
  	clubcrawlers]
  	
  	#everything needs cateogry
  	#nomagazine problem with preregister location
  	#justshows isnt appearing?
  	#problem with price for jsutshows
  	#parks,
  	#eventful,
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
  																  	val.xpath("//entrydata[@name='TimeBegin']")[count].text=="" ? "Start time not listed" : val.xpath("//entrydata[@name='TimeBegin']")[count].text, 
  																  	val.xpath("//entrydata[@name='DateEndShow']")[count].text, 
  																 	val.xpath("//entrydata[@name='TimeEnd']")[count].text=="" ? "End time not listed" : val.xpath("//entrydata[@name='TimeEnd']")[count].text,
  																  	val.xpath("//entrydata[@name='Admission']")[count].text=="" ? "Price not listed" : val.xpath("//entrydata[@name='Admission']")[count].text,
  																  	val.xpath("//entrydata[@name='Location']")[count].text,
  																 	val.xpath("//entrydata[@name='CategoryList']")[count].text]

  		end
  		count+=1
  	end

  		#count+=1
  	#end
  	#date===range
  	info
  	#December 4, 2013
  end
#toronto christmas market time
#
  def nowmagazine
  	#trouble with getting the values out to get the date
  	#trouble if in description says:  Nov 28 to Dec 8 weekdays and Sat 10 am-9 pm, Thu 10 am-11 pm, Sun 10 am-6 pm
  	#time, price, address
  	#NEEDS CATEGORY
  	info={}
  	date=DateTime.now
  	data=Nokogiri::HTML(open("http://www.nowtoronto.com/news/listings/"))
  	.css(".listing-entry")[0].css("div[class^='listing-item']")
  	#data.css("div.day#{date.day}month#{date.month}")

	data.each do |val|
	  		info[val.css("span.List-Name").text]=[]
	
	  		price=val.css("div.List-Body").text[/\$\w+|[fF]ree|Donation/]
	  		if price==nil
	  			price="Price Varies"
	  		end
	  		address= val.css("div.List-Body").text[/\s[0-9]+\s[A-Z][a-z]+.+,/]
	  		if address==nil || address.size>20
	  			address=val.css("div.List-Body").text.split(",")[-2]
	  		else
	  			address=address[0...-1]
	  		end
	  		time=val.css("div.List-Body").text[/([0-9]+:)?[0-9]+\s(a|p)m(-[0-9]+\s(a|p)m)?/]
	  		if time==nil
	  			time="Not provided"
	  		end
	  		info[val.css("span.List-Name").text]=[price,address,time]
	  		
	  	end
  	#string4[/[0-9]+\s[A-Z][a-z]+(\b[A-Z][a-z]+)*?/]
  	#i know that second last thing is always location so can split on that?! not always
  	info

  end

  def xlsattraction
  	#need to make list of things. i guess snakes and lattes and other things
  	# we curate can be in here. blog to entries added to this list?
  	#feeling touristry and not too late (if event happeneing late would be mentioned on city of toronto)
  end

  def eventbrite
  	info={}
  	#name=time (need to extract time), tickets[price], address NEED CATEGORY TO ATTRBIUTE
  	data=JSON.parse((open("http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=today&max=100")).read)
  	data=data["events"]
  	data[1..100].each do |event|
		info[event["event"]["title"]]=[event["event"]["start_date"][/\d+:\d+:\d+/],event["event"]["tickets"][0]["ticket"]["price"]=="0.00" || event["event"]["tickets"][0]["ticket"]["price"]==nil ? "Free" : event["event"]["tickets"][0]["ticket"]["price"] ,event["event"]["venue"]["address"]]
	end
	info
  	
  end
  	
  def parks
  	
  end

  def eventful
  	JSON.parse((open("http://api.eventful.com/json/events/search?app_key=hSXmLwVD99qfGPBs&location=Toronto&t=today&page_size=200")).read)
  	#same technique in eventbrite
  end

  def clubcrawlers
  	#only if like five pm time or later
  	info={}
  	even=Nokogiri::HTML(open("http://www.clubcrawlers.com/toronto/nightclubs/allvenues?crowd=&sort=p#listings")).css(".club-block")
  	odd=Nokogiri::HTML(open("http://www.clubcrawlers.com/toronto/nightclubs/allvenues?crowd=&sort=p#listings")).css(".club-block.odd")
  	clubs=even+odd
  	clubs.each do |val|
  		info[val.css("div.event-info h2 a").text]=[val.css("div.event-info p.club-listing-address").text]
  	end
  	info

  end

  def justshows
  	#all events=even=Nokogiri::HTML(open("http://justshows.com/toronto/")).css("ul.shows li")
  	#time, price, location, #NEED CATEGORY - ALL WIL BE MUSIC HERE?
  	#might be problem if performers are playing twice on different days
  	info1={}
  	date=Date.today.strftime("%a")+" "+ Date.today.strftime("%B")[0..2]+" " + Date.today.strftime("%01d")

  	data=Nokogiri::HTML(open("http://justshows.com/toronto/")).css("ul.shows li")
  	data.each do |val| 
  		
  		if date == val.css("strong.day").text
  			#p val.css("title").text
  			#p val.css("span.time").text 
  			#p val.css("strong.location").text
  			#p val.css("span.venue-meta").text[/\$\d+\.\d+\s(-\d*)?[^All]+/]
  			info1[val.css("strong.summary").text]=[val.css("span.time").text, 
  													val.css("strong.location").text 
  													]
  			if (val.css("span.venue-meta").text[/\$\d+\.\d+\s(-$\d+\.\d+)?[^All]+/])==nil
  				info1[val.css("strong.summary").text]<<val.css("span.venue-meta").text[/\$\d+\s[^all]+/i]
  			else
  				info1[val.css("strong.summary").text] << val.css("span.venue-meta").text[/\$\d+\.\d+\s(-$\d+\.\d+)?[^All]+/]
  			end
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
  	#need ip to get distances for everyone. lazy, travel
  end

  def meetup
  	#time, price, location
  	info={}

	data=JSON.parse(open("https://api.meetup.com/2/open_events?&sign=true&city=Toronto&country=ca&time=0d,1d&status=upcoming&key=7b794c3657477db4e107a7e366f7b5f").read)['results']
	data.each do |val|
		today=Time.at(val["time"]/1000).strftime(("%B %01d, %Y"))
		#"December 4, 2013"
		date=Date.today.strftime("%B %01d, %Y")
		#Wed, 04 Dec 2013
		
		if today==date
			info[val["name"]]=[Time.at(val["time"]/1000).strftime("%I:%M %p")]
			if val["fee"]
				info[val["name"]]<<val["fee"]["amount"]
			else
				info[val["name"]] << "Free"
			end
			if val["venue"]!=nil

				info[val["name"]]<< val["venue"]["address_1"] if val["venue"]["city"]=="Toronto" 
		
				info[val["name"]]<< val["venue"]["address_1"]+ " " + val["venue"]["city"] if val["venue"]["city"]!="Toronto"
			else
				info[val["name"]] << "No location listed"
			end
		end
	end
	info 	
  end


end


