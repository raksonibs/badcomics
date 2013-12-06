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
	@@called={Date.today.strftime("%B %01d, %Y")=>false}
	#doesn't work when close browser. need to do the script thing

	def index
  	#makeevents unless @@called[Date.today.strftime("%B %01d, %Y")]
  	respond_to do |format|
  		
  		if params[:button]=="Lazy"
  			
  			
  			@data=Event.near([params[:latitude],params[:longitude]],1, :units => :km)

  			format.js{}
  		else
  			@cat=[]
  			Event.all.each_with_index do |e,i|
  				@cat<<e.price if !(@cat.include?(e.price))
  				
  			end
  			format.html{ @data=Event.all }
  		end
  	end
  	@called=@@called
  end

=begin
  def index
  	#need to formalize times and prices
  	@cat=[]
  			Event.all.each_with_index do |e,i|
  				@cat<<e.price if !(@cat.include?(e.price))
  				
  			end
  			@data=nowmagazine
  end
=end
  
  def algorthim
  	#/result/happy/art/20
  	feeling,activity,money=params[:feeling], params[:activity], params[:money].to_i #also params[geolocation]
  	timenow=Time.now
  	if money=="Free"
  		@data=Event.all
  	else
  		
  		#price not listed not accounted for
  		#have to format time ugh
  		#want to make better loop
  		@data=[]

  		Event.all[0..40].each do |e|
  			if e.time=="Time not listed" || Time.parse(e.time) > timenow 

  				if e.price =="Free" || e.price=="Price not listed" || e.price <= params[:money]
  					
  					if e.category.match(/#{activity}/i)
  						

  						@data << e
  					end
  				end
  			end

  		end
  		#@data=Event.where("price<=#{params[:money]} AND time>#{timenow}") + Event.where("price=='Free' AND time>#{timenow}")
  	end
  	#greater for time means in the future?

  	first={}
  	firstn=""
  	second={}
  	secondn=""
  	third={}
  	thirdn=""
  	@scores=[]
  	@data.each_with_index do |val,i|
  		#no distance yet in alg

  		score=score(calculateprice(val), 25, calculatepurity(val), calculatetime(val))
  		@scores << {score=>val.name}
  		if i==0
  			firstn=val.name
  			first[val.name]=score
  		else
  			#should do recursive
  			if score> first[firstn]
  				if secondn==""
  					secondn=firstn
  					second[secondn]=first[firstn]
  					first.delete(firstn)
  					firstn=val.name
  					first[firstn]=score
  				else

  					third.delete(thirdn) if thirdn!="" #if second exists, delete third
  					thirdn=secondn
  					third[thirdn]=second[secondn]
  					second.delete(secondn)
  					secondn=firstn
  					second[secondn]=first[firstn]
  					first.delete(firstn)
  					firstn=val.name
  					first[firstn]=score
  				end
  			elsif secondn=="" || score>second[secondn] 
  				if secondn==""
  					secondn=val.name
  					second[secondn]=score
  				else

  					third.delete(thirdn) if thirdn!="" #if second exists, delete third
  					thirdn=secondn
  					third[thirdn]=second[secondn]
  					second.delete(secondn)
  					secondn=val.name
  					second[secondn]=score
  					
  				end
  			elsif thirdn=="" || score>third[thirdn]
  				third.delete(thirdn) if thirdn!="" #if second exists, delete third
  				thirdn=secondn
  				third[thirdn]=score
  			end
  		end


  	end
  		@result=[first,second,third]		


  end

  def calculatetime(val)
  	mult=0
  	time=val.time

  	if time=="Time not listed"
  		mult=rand()
  	else
  		mult=1
  	end
  	
  	score =mult*((33.33-25)*2)

  end

  def calculateprice(val)
  	price=val.price
  	mult=0
  	
  	if price== "Free"
  		mult=1
  	elsif price=="Price not listed"

  		mult=rand()
  		
  	elsif price.to_i <= 10
  		mult=0.9
  	elsif price.to_i <=20
  		mult=0.8
  	elsif price.to_i <= 30
  		mult=0.7
  	elsif price <= 40
  		mult=0.6
  	elsif price.to_i <= 50
  		mult=0.5
  	elsif price.to_i <= 75
  		mult=0.4
  	elsif price.to_i <= 100
  		mult=0.3
  	elsif price.to_i <= 150
  		mult=0.2
  	elsif price.to_i <= 200
  		mult=0.1
  	else

  		mult=rand()
  	end
  	score=mult*25


  end

  def calculatedistance(val)
  	#need their ip
  	#from params location, get distance from then use val.distance_from(ip address location) and find smallest distance
  	distance=val.distance
  	mult=0
  	if distance<=1
  		mult=1
  	elsif distance>1 && distance<=3
  		mult=0.85
  	elsif distance>3 && distance<=6
  		mult=0.70
  	elsif distance>6 && distance<=10
  		mult=0.55
  	elsif distance>10 && distance<=15
  		mult=0.35
  	elsif distance>15 && distance<=25
  		mult=0.1
  	else
  		mult=0
  	end
  	score=mult*33.3333
  end

  def calculatepurity(val)
  	category=val.category.count("/")
  	mult=0
  	if category==0
  		mult=1
  	elsif category==1
  		mult=0.8
  	elsif category==2
  		mult=0.6
  	elsif category==3
  		mult=0.4
  	elsif category==4
  		mult=0.2
  	elsif category>=5
  		mult=0.1
  	else
  		mult=0
  	end
  	score=mult*33.3333

  end

  def score(val,val2,val3,val4)
  	val+val2+val3+val4
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
  	@@called[Date.today.strftime("%B %01d, %Y")]=true
  end

  def home
    # if params[:button]
    #   @feeling = Event.find(params[:button]
    #   elsif params[:button1]
    #   @category = Event.find(params[:button1])
    #   elsif params[:button1]
    #   @price = Event.find(params[:button2])
    # end
  end



  def getdata
  	[cityhall,
  	nowmagazine,
  	eventbrite,
  	justshows,
  	clubcrawlers,
  	meetup,
  	roo
  	]
  	
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
  	
  	
  	#taking only high price

  	data.each do |val|
  		range = Date.parse(val.xpath("//entrydata[@name='DateBeginShow']")[count].text) .. Date.parse(val.xpath("//entrydata[@name='DateEndShow']")[count].text)
  		if range.include?(date)
  			info[val.xpath("//entrydata[@name='EventName']")[count].text]=[
  																  	val.xpath("//entrydata[@name='TimeBegin']")[count].text=="" ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeBegin']")[count].text).strftime("%I:%M %p")]
  																  	
  																 
  			price=val.xpath("//entrydata[@name='Admission']")[count].text=="" ? "Price not listed" : val.xpath("//entrydata[@name='Admission']")[count].text
  			if price[/ - /]
  				price=price[/\s\$\d+/]
  				price=price[/\d+/]
  				info[val.xpath("//entrydata[@name='EventName']")[count].text] << price
  			else
  				if price=="Free" || price=="Price not listed"
  					info[val.xpath("//entrydata[@name='EventName']")[count].text] << price
  				else
  					info[val.xpath("//entrydata[@name='EventName']")[count].text]<< price[/\d+/]
  				end
  			end
  			info[val.xpath("//entrydata[@name='EventName']")[count].text]<< val.xpath("//entrydata[@name='Location']")[count].text
  			value=val.xpath("//entrydata[@name='CategoryList']")[count].text
  			if value[/talk/i] || value[/symposium/i] || value[/screening/i] || value[/lecture/i] || value[/speak/i] || value[/dicuss/i]
	  			category="Talk"
	  		end
	  		if value[/music/i]
	  			category = category==nil ? "Music" : category+"/Music"
	  		end
	  		if value[/perform.*/i]
	  			category = category==nil ? "Theatre" : category+"/Theatre"
	  		end
	  		if value[/read.*/i] || value[/novel/i]
	  			category = category==nil ? "Reading" : category+"/Reading"
	  		end
	  		if value[/festiv.*/i] || value[/holiday/i] || value[/christmas/i] || value[/carol/i] || value[/celebra.*/i]
	  			category = category==nil ? "Seasonal" : category+"/Seasonal"
	  		end
	  		if value[/party/i] || value[/bash/i]
	  			category = category==nil ? "Party" : category+"/Party"
	  		end
	  		if value[/fundrais.*/i] || value[/auction/i]
	  			category = category==nil ? "Charity" : category+"/Charity"
	  		end
	  		if value[/comed.*/i] || value[/laugh/i]
	  			category = category==nil ? "Comedy" : category+"/Comedy"
	  		end
	  		if value[/^art.*/i] || value[/gallery/i]
	  			category = category==nil ? "Art" : category+"/Art"
	  		end
	  		if value[/sport.*/i] || value[/dance/i]|| value[/athletic/i] || value[/hockey/i] || value[/basketball/i] || value[/baseball/i] || value[/swimming/i] || value[/football/i] || value[/tennis/i] || value[/golf/i] || value[/soccer/i]
	  			category = category==nil ? "Sport" : category+"/Sport"
	  		end
	  		if value[/family.*/i] || value[/children/i]
	  			category = category==nil ? "Family" : category+"/Family"
	  		end
	  		if category==nil
	  			category="Misc."
	  		end
	  		info[val.xpath("//entrydata[@name='EventName']")[count].text] << category
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
  	#trouble with getting the descs out to get the date
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
	  			price="Price not listed"
	  		end
	  		address = val.css("div.List-Body").text[/[0-9]+\s[A-Z][a-z]+.+/]

	  		if address==nil || address.size>20
	  			address=val.css("div.List-Body").text.split(",")[-2]
	 
	  		end
	  		if address!=nil
	  			if address.size>20

	  			address=val.css("div.List-Body").text[/\d+\s[A-Z][a-z]+/]
	  			end
	  		end
	  		if address==nil
	  			address="Address not listed"
	  		end
	  		

	  		
	  		
	  		time=val.css("div.List-Body").text[/([0-9]+:)?[0-9]+\s(a|p)m(-[0-9]+\s(a|p)m)?/]
	  		if time==nil
	  			time="Time not listed"
	  		else
	  			time=Time.parse(time).strftime("%I:%M %p")
	  		end
	  		value=val.css("div.List-Body").text
	  		if value[/talk/i] || value[/symposium/i] || value[/screening/i] || value[/lecture/i] || value[/speak/i] || value[/dicuss/i]
	  			category="Talk"
	  		end
	  		if value[/music/i]
	  			category = category==nil ? "Music" : category+"/Music"
	  		end
	  		if value[/perform.*/i]
	  			category = category==nil ? "Theatre" : category+"/Theatre"
	  		end
	  		if value[/read.*/i] || value[/novel/i]
	  			category = category==nil ? "Reading" : category+"/Reading"
	  		end
	  		if value[/festiv.*/i] || value[/holiday/i] || value[/christmas/i] || value[/carol/i]
	  			category = category==nil ? "Seasonal" : category+"/Seasonal"
	  		end
	  		if value[/party/i] || value[/bash/i]
	  			category = category==nil ? "Party" : category+"/Party"
	  		end
	  		if value[/fundrais.*/i] || value[/auction/i]
	  			category = category==nil ? "Charity" : category+"/Charity"
	  		end
	  		if value[/comed.*/i] || value[/laugh/i]
	  			category = category==nil ? "Comedy" : category+"/Comedy"
	  		end
	  		if value[/^art.*/i] || value[/gallery/i]
	  			category = category==nil ? "Art" : category+"/Art"
	  		end
	  		if value[/sport.*/i] || value[/athletic/i] || value[/hockey/i] || value[/basketball/i] || value[/baseball/i] || value[/swimming/i] || value[/football/i] || value[/tennis/i] || value[/golf/i] || value[/soccer/i]
	  			category = category==nil ? "Sport" : category+"/Sport"
	  		end
	  		if value[/family.*/i] || value[/children/i]
	  			category = category==nil ? "Family" : category+"/Family"
	  		end
	  		if category==nil
	  			category="Misc."
	  		end

	  			
	  			
	  		info[val.css("span.List-Name").text]=[time,price[/\$/]!=nil ? price[/\w+/] : price ,address[1..address.size]+", Toronto, ON, Canada",category]
	  		
	  	end
  	#string4[/[0-9]+\s[A-Z][a-z]+(\b[A-Z][a-z]+)*?/]
  	#i know that second last thing is always location so can split on that?! not always
  	info

  end

  def eventbrite
  	info={}
  	#name=time (need to extract time), tickets[price], address NEED CATEGORY TO ATTRBIUTE
  	data=JSON.parse((open("http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=today&max=100")).read)
  	data=data["events"]
  	data[1..100].each do |event|
  		unless event["event"]["category"][/seminar/] || event["event"]["category"][/sales/]
		info[event["event"]["title"]]=[Time.parse(event["event"]["start_date"][/\d+:\d+:\d+/]).strftime("%I:%M %p"),event["event"]["tickets"][0]["ticket"]["price"]=="0.00" || event["event"]["tickets"][0]["ticket"]["price"]==nil ? "Free" : event["event"]["tickets"][0]["ticket"]["price"] ,event["event"]["venue"]["address"]]
		desc= event["event"]["category"]==""|| event["event"]["category"]==nil ? "Misc." : event["event"]["category"]
		if desc[/seminar/] || desc[/conference/] 
	  		category="Talk"
	  	end
	  	if desc[/music/i] || desc[/performan/i]
	  		category = category==nil ? "Music" : category+"/Music"
	  	end
	  	if desc[/comedy/i]
	  		category = category==nil ? "Comedy" : category+"/Comedy"
	  	end
	  	if desc[/entertainment/i]
	  		category = category==nil ? "Party" : category+"/Party"
	  	end
	  	if desc[/party/i]
	  		category = category==nil ? "Party" : category+"/Party"
	  	end
	  	if desc[/Sport/i]
	  		category = category==nil ? "Sport" : category+"/Sport"
	  	end
	  	if desc[/Social/i]
	  		category = category==nil ? "Hang Out" : category+"/Hang Out"
	  	end
	  	if desc[/fundrais/i]
	  		category = category==nil ? "Charity" : category+"/Charity"
	  	end
	  	if category==nil
	  		category="Misc."
	  	end
	  	info[event["event"]["title"]] << category
	  end
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
  		info[val.css("div.event-info h2 a").text]=["Time not listed", "Price not listed", val.css("div.event-info p.club-listing-address").text,"Party"]
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
  			info1[val.css("strong.summary").text]=[Time.parse(val.css("span.time").text).strftime("%I:%M %p")
  											
  									
  													]
  			if (val.css("span.venue-meta").text[/\$\d+(\.\d+\s)?(-$\d+\.\d+)?[^All]+/])==nil

  				price=val.css("span.venue-meta").text[/\$\d+\s[^all]+/i]

  				if val.css("span.venue-meta").text=="Free"
  					price="Free"
  				else
  					price=price[/\d+/]

  				end

  				
  			else
  				price=val.css("span.venue-meta").text[/\$\d+(\.\d+\s)?(-$\d+\.\d+)?[^All]+/]
  				price=price[/\d+/]
  			end
  			info1[val.css("strong.summary").text]<< price
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
				info[val["name"]] << "Address not listed"
			end
			desc=val["description"]
			if desc[/talk/i] || desc[/symposium/i] || desc[/screening/i] || desc[/lecture/i] || desc[/speak/i] || desc[/dicuss/i]
	  			category="Talk"
	  		end
	  		if desc[/music/i]
	  			category = category==nil ? "Music" : category+"/Music"
	  		end
	  		if desc[/perform.*/i]
	  			category = category==nil ? "Theatre" : category+"/Theatre"
	  		end
	  		if desc[/read.*/i] || desc[/novel/i]
	  			category = category==nil ? "Reading" : category+"/Reading"
	  		end
	  		if desc[/festiv.*/i] || desc[/holiday/i] || desc[/christmas/i] || desc[/carol/i]
	  			category = category==nil ? "Seasonal" : category+"/Seasonal"
	  		end
	  		if desc[/party/i] || desc[/bash/i]
	  			category = category==nil ? "Party" : category+"/Party"
	  		end
	  		if desc[/fundrais.*/i] || desc[/auction/i]
	  			category = category==nil ? "Charity" : category+"/Charity"
	  		end
	  		if desc[/comed.*/i] || desc[/laugh/i]
	  			category = category==nil ? "Comedy" : category+"/Comedy"
	  		end
	  		if desc[/^art.*/i] || desc[/gallery/i]
	  			category = category==nil ? "Art" : category+"/Art"
	  		end
	  		if desc[/sport.*/i] || desc[/athletic/i] || desc[/hockey/i] || desc[/basketball/i] || desc[/baseball/i] || desc[/swimming/i] || desc[/football/i] || desc[/tennis/i] || desc[/golf/i] || desc[/soccer/i]
	  			category = category==nil ? "Sport" : category+"/Sport"
	  		end
	  		if desc[/family.*/i] || desc[/children/i]
	  			category = category==nil ? "Family" : category+"/Family"
	  		end
	  		if category==nil
	  			category="Misc."
	  		end

			info[val["name"]] << category
		end
	end
	info	
  end

  def roo
  	attracts
  	
  end


end


