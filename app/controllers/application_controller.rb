class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def attracts
		info={}
		#price(nonexistant), category, address
		oo=Roo::Excel.new("places_of_attraction.xls")
		(oo.last_row-1).times do |i|
			info[oo.cell(i+2,"F")]=["Time not listed", "Price not listed", oo.cell(i+2,"C") +", Toronto, ON, Canada", oo.cell(i+2, "J")]
		end
		info
	end


  	def makeevents
  	#each data name=>[time, price, location, category]
  	#feeling will always be none
  	#geocoding overusing api, that is why inconsisitent geocoding.
	  	Event.all.delete_all
	  	@data=getdata
	  	  	@data.each do |source|
	  	  		source.keys.each do |k|


	  	  				e=Event.new(name:k, time:source[k][0], price:source[k][1], location:source[k][2], category:source[k][3], feeling: "None")
	  	  				e.geocode
	  	  				e.save
	  	  				sleep(1)

	  	  		end
	  	  	end
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
  	roo,
  	startupdigest
  	]
  	#parks,
  	#eventful,
  	#unqiuefinds
  	#facebook
  end

  def cityhall
  	info={}
  	date=Date.today#.strftime("%B %01d, %Y")
  	data=Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
  	countend=data.size
  	count=0
  	dates=["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  	data.each do |val|
  		range = Date.parse(val.xpath("//entrydata[@name='DateBeginShow']")[count].text) .. Date.parse(val.xpath("//entrydata[@name='DateEndShow']")[count].text)
  		if range.include?(date)
			if dates.any?{|dat| val.xpath("//entrydata[@name='EventName']")[count].text[/#{dat}/]}
  				if val.xpath("//entrydata[@name='EventName']")[count].text[/#{date.strftime("%A")}/]
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
		  			info[val.xpath("//entrydata[@name='EventName']")[count].text]<< val.xpath("//entrydata[@name='Location']")[count].text+ ", Toronto, ON, Canada"
		  			value=val.xpath("//entrydata[@name='CategoryList']")[count].text
		  			if value[/talk/i] || value[/symposium/i] || value[/screening/i] || value[/lecture/i] || value[/speak/i] || value[/dicuss/i]
			  			category="Reading"
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
			  		if value[/tech.*/i]
			  			category = category==nil ? "Tech" : category+"/Tech"
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
			  			value=val.xpath("//entrydata[@name='Performance']")[count].text
			  			if value[/perform.*/i]
			  				category = category==nil ? "Theatre" : category+"/Theatre"
			  			else
			  				category="Misc."
			  			end
			  		end
			  		info[val.xpath("//entrydata[@name='EventName']")[count].text] << category
	  			end
		  	else
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
		  			info[val.xpath("//entrydata[@name='EventName']")[count].text]<< val.xpath("//entrydata[@name='Location']")[count].text+ ", Toronto, ON, Canada"
		  			value=val.xpath("//entrydata[@name='CategoryList']")[count].text
		  			if value[/talk/i] || value[/symposium/i] || value[/screening/i] || value[/lecture/i] || value[/speak/i] || value[/dicuss/i]
			  			category="Reading"
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
			  		if value[/tech.*/i]
			  			category = category==nil ? "Tech" : category+"/Tech"
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
			  			value=val.xpath("//entrydata[@name='Performance']")[count].text
			  			if value[/perform.*/i]
			  				category = category==nil ? "Theatre" : category+"/Theatre"
			  			else
			  				category="Misc."
			  			end
			  		end
			  		info[val.xpath("//entrydata[@name='EventName']")[count].text] << category
	  		end

  		end

  		count+=1
  	end
  	info
  end

  def startupdigest
  	#wish had times
  	#Tue Dec 17, 2013 6:30pm to Tue Dec 17, 2013 8:30pm 
  	#each data name=>[time, price, location, category]
  	@data=Nokogiri::XML(open("https://www.google.com/calendar/feeds/startupdigest.com_ladfoeq440djsjmb5ila0nphss%40group.calendar.google.com/public/basic")).css("title[@type='html']").zip(Nokogiri::XML(open("https://www.google.com/calendar/feeds/startupdigest.com_ladfoeq440djsjmb5ila0nphss%40group.calendar.google.com/public/basic")).css("summary[@type='html']").zip(Nokogiri::XML(open("https://www.google.com/calendar/feeds/startupdigest.com_ladfoeq440djsjmb5ila0nphss%40group.calendar.google.com/public/basic")).css("content[@type='html']")))
  	info={}
  	@data.each do |val|
  		#date=Date.today.strftime("%B %01d, %Y")
  		date=Date.today.strftime("%a %b %01d %Y")
  		#date=Time.parse("Mon Dec 9 2013 6:30pm").strftime("%a %01d %b %Y")
  		
  		#val[1][0].text[/([A-Z][a-z]+\s\d+\s[A-Z][a-z]+\s\d+)+/]
  		if val[1][0].text[/#{date}/]
  			
  			info[val[0].text]=[Time.parse(val[1][0].text[/\d+:\d+/]).strftime("%I:%M %p")]
  			
  			if val[1][1].text[/Price/]
  				info[val[0].text]<<val[1][1].text[/Free/] if val[1][1].text[/Free/]
  				info[val[0].text]<<val[1][1].text[/Price:?\$?\s?\$?\d+/][/\d+/] if val[1][1].text[/Price:?\$?\s?\$?\d+/]
  				

  			else
  				info[val[0].text]<<"Price not listed"
  			end

  			 info[val[0].text]<<val[1][0].text[/Where.*nto/][/\d+\s[A-Z][a-z]+(\s[A-Z][a-z]+)+?/]+", Toronto, ON, Canada" 
  			 info[val[0].text]<<"Tech"
  		end
  	end
  	@data=info

  end

  def nowmagazine
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
	  		if value[/tech.*/i]
	  			category = category==nil ? "Tech" : category+"/Tech"
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
  	info
  end

  def eventbrite
  	info={}
  	
  	data=JSON.parse((open("http://www.eventbrite.com/json/event_search?app_key=GUBRP2USZMDRRVPPSF&city=Toronto&date=today&max=100")).read)
  	data=data["events"]
  	data[1..100].each do |event|
  		unless event["event"]["category"][/seminar/] || event["event"]["category"][/sales/]
		info[event["event"]["title"]]=[Time.parse(event["event"]["start_date"][/\d+:\d+:\d+/]).strftime("%I:%M %p"),event["event"]["tickets"][0]["ticket"]["price"]=="0.00" || event["event"]["tickets"][0]["ticket"]["price"]==nil ? "Free" : event["event"]["tickets"][0]["ticket"]["price"] ,event["event"]["venue"]["address"]+", Toronto, ON, Canada"]
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
	  	if desc[/tech.*/i]
	  			category = category==nil ? "Tech" : category+"/Tech"
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
  		info[val.css("div.event-info h2 a").text]=["Time not listed", "Price not listed", val.css("div.event-info p.club-listing-address").text+", Toronto, ON, Canada","Party"]
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
  			info1[val.css("strong.summary").text]=[Time.parse(val.css("span.time").text).strftime("%I:%M %p")]
  			if (val.css("span.venue-meta").text[/\$\d+(\.\d+\s)?(-$\d+\.\d+)?[^All]+/])==nil

  				price=val.css("span.venue-meta").text[/\$\d+\s[^all]+/i]

  				if val.css("span.venue-meta").text=="Free"
  					price="Free"
  				else
  					
  					if price!=nil
  						if price[/\d+/]
  						
  							price=price[/\d+/]
  						end
  					else
  						price="Price not listed"
  					end
  					

  				end

  				
  			else
  				price=val.css("span.venue-meta").text[/\$\d+(\.\d+\s)?(-$\d+\.\d+)?[^All]+/]
  				price=price[/\d+/]
  			end
  			info1[val.css("strong.summary").text]<< price
  			info1[val.css("strong.summary").text] << (val.css("strong.location").text)
  			info1[val.css("strong.summary").text] << "Music"
  		end
  	end
  	info1
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

  def techvibes
  	#wish had times
  	data=Nokogiri::HTML(open("http://www.techvibes.com/event/toronto")).css("article.event")

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
	  		if desc[/tech.*/i]
	  			category = category==nil ? "Tech" : category+"/Tech"
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
