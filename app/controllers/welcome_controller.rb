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
#mirvish toronto
#foursquare
class WelcomeController < ApplicationController
	@@called={Date.today=>false}
  def index
  	makeevents unless @@called[Date.today]
  	@data=Event.all
  	@called=@@called
  end

  def makeevents
  	#ugly need to change
  	#need to standardize each one so don't have to conditional. make
  	#each data name=>[time, price, location, category]
  	#feeling will always be none
  	Event.all.delete_all
  	@data=getdata
  	  	@data.each do |source|
  	  		source.keys.each do |k|


  	  				e=Event.new(name:k, time:source[k][0], price:source[k][1], location:source[k][2], category:source[k][3], feeling: "None")
  	  				e.save

  	  		end
  	  	end
  	@@called[Date.today]=true
  end

  def home
  end



  def getdata
  	[cityhall,
  	nowmagazine,
  	eventbrite,
  	justshows,
  	clubcrawlers,
  	meetup,
  	roo]
  	
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
  			info[val.xpath("//entrydata[@name='EventName']")[count].text]=[
  																  	val.xpath("//entrydata[@name='TimeBegin']")[count].text=="" ? "Start time not listed" : val.xpath("//entrydata[@name='TimeBegin']")[count].text, 
  																  	
  																 
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
  	#categoirs seem talk(talk, symposium, screening, lecture, speak, discuss), music(music) theatre(performances), reading(reading, novel), comedy, seasonal(festiv,holiday, carol, christmas), party(party), charity(fundrais, auction), miscelianous (everything else) 
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
	  		address = val.css("div.List-Body").text[/\s[0-9]+\s[A-Z][a-z]+.+,/]
	  		if address==nil || address.size>20
	  			address=val.css("div.List-Body").text.split(",")[-2]
	 
	  		end
	  		if address!=nil
	  			if address.size>20

	  			address=val.css("div.List-Body").text[/\d+\s[A-Z][a-z]+/]
	  			end
	  		end
	  		if address==nil
	  			address="Not provided"
	  		end
	  		

	  		
	  		
	  		time=val.css("div.List-Body").text[/([0-9]+:)?[0-9]+\s(a|p)m(-[0-9]+\s(a|p)m)?/]
	  		if time==nil
	  			time="Not provided"
	  		end
	  		value=val.css("div.List-Body").text
	  		if value[/talk/i] || value[/symposium/i] || value[/screening/i] || value[/lecture/i] || value[/speak/i] || value[/dicuss/i]
	  			category="Talk"
	  		elsif value[/music/i]
	  			category="Music"
	  		elsif value[/perform.*/i]
	  			category="Theatre"
	  		elsif value[/read.*/i] || value[/novel/i]
	  			category="Reading"
	  		elsif value[/festiv.*/i] || value[/holiday/i] || value[/christmas/i] || value[/carol/i]
	  			category="Seasonal"
	  		elsif value[/party/i] || value[/bash/i]
	  			category="Party"
	  		elsif value[/fundrais.*/i] || value[/auction/i]
	  			category="Charity"
	  		else
	  			category="Misc."
	  		end

	  			
	  			
	  		info[val.css("span.List-Name").text]=[time,price,address,category]
	  		
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
		info[event["event"]["title"]]=[event["event"]["start_date"][/\d+:\d+:\d+/],event["event"]["tickets"][0]["ticket"]["price"]=="0.00" || event["event"]["tickets"][0]["ticket"]["price"]==nil ? "Free" : event["event"]["tickets"][0]["ticket"]["price"] ,event["event"]["venue"]["address"], event["event"]["category"]==nil ? "Misc." : event["event"]["category"]]
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
  		info[val.css("div.event-info h2 a").text]=["Time Depends", "Price Depends", val.css("div.event-info p.club-listing-address").text,"Party"]
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
  			info1[val.css("strong.summary").text]=[val.css("span.time").text 
  											
  									
  													]
  			if (val.css("span.venue-meta").text[/\$\d+\.\d+\s(-$\d+\.\d+)?[^All]+/])==nil
  				info1[val.css("strong.summary").text]<<val.css("span.venue-meta").text[/\$\d+\s[^all]+/i]
  			else
  				info1[val.css("strong.summary").text] << val.css("span.venue-meta").text[/\$\d+\.\d+\s(-$\d+\.\d+)?[^All]+/]
  			end
  			info1[val.css("strong.summary").text] << val.css("strong.location").text
  			info1[val.css("strong.summary").text] << "Music"
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
  	#no way to categorize
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
			info[val["name"]] << "Misc."
		end
	end
	info 	
  end

  def roo
  	attracts
  	
  end


end


