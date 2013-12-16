require 'open-uri'
require 'nokogiri'
require 'active_support/core_ext/numeric/time'
#attractions for touristy like snakes and latteees. unique finds section?
#also want like facebook friend parties
#also funny things like sleep? maybe shouldnt tell them what to do lol
#tag based on season
#mirvish toronto
#foursquare
class WelcomeController < ApplicationController
        @@all||=nil
        @@allprice||=nil
        @@alltime||=nil
        @@alldist||=nil
  def index
  	if current_user
  		@result=current_user.choices
  		catchoice=categorycount(@result)
  		pricechoice=pricecount(@result)
  		feelingchoice=feelingscount(@result)[1]
  		@result=algorthim(feelingchoice, catchoice,pricechoice,true)
  		#@friends = JSON.parse(open("https://graph.facebook.com/513002328/friends?access_token=485668664879205").read)
  		#user = FbGraph::User.me(token.strip)
  		#@graph = Koala::Facebook::API.new(oauth_access_token)

		#profile = @graph.get_object("me")
		#friends = @graph.get_connections("me", "friends")

  		user = FbGraph::User.fetch("oskarniburski", :access_token => current_user.oauth_token)
  		@friends= user.friends


  		#Fql.execute("SELECT uid FROM use WHERE is_app_use=true AND uid IN (SELECT uid2 FROM friend WHERE uid1 = current_user.uid)")

  	end
  	#@result=Fql.execute("SELECT first_name, last_name FROM user WHERE uid = #{current_user.uid}")
  	#@result=Fql.execute("SELECT uid,eid,rsvp_status FROM event_member WHERE uid = #{current_user.uid}")
  	#@result=Fql.execute("SELECT name, attending_count, start_time, eid, location FROM event WHERE eid IN (SELECT eid FROM event_member WHERE uid = #{current_user.uid})")

  end
def test
	user = FbGraph::User.fetch("oskarniburski", :access_token => current_user.oauth_token)
  @installed={}
  friends= user.friends
  # friends.each do |friend|

  @installed=JSON.parse(open("https://graph.facebook.com/#{current_user.uid}/friends?access_token=CAAG90loE5l8BAGYHDhEUWri968ZAkwZBX5JN2SQOrK1dKPbZBWdjQ1DVIdojXBNQQ6CHNAnJ0l5sJANfERGxmZAWAfudZAEPWvjji1mL3nEyZABzvTfMW3eBgWEQHmYvOK9DbgpbzVmmMWJ8R6uehjs7ZCSRfyJKK9PPxhLCDwMR0Pq2tUFa0sgHNWz4heTkRAZD&fields=installed").read)['data']
  # 	if val["installed"]
  # 	  @installed[friend.id]=true
  # 	  debugger
  # 	end
  # end

  	# /me/friends?fields=installed
  	#@installed=JSON.parse(open("https://graph.facebook.com/513002328?access_token=CAAG90loE5l8BAGYHDhEUWri968ZAkwZBX5JN2SQOrK1dKPbZBWdjQ1DVIdojXBNQQ6CHNAnJ0l5sJANfERGxmZAWAfudZAEPWvjji1mL3nEyZABzvTfMW3eBgWEQHmYvOK9DbgpbzVmmMWJ8R6uehjs7ZCSRfyJKK9PPxhLCDwMR0Pq2tUFa0sgHNWz4heTkRAZD&fields=installed").read)
  	#@installed=JSON.parse(open("https://graph.facebook.com/#{current_user.uid}/friends?fields=installed").read)
  	#@installed=FbGraph::Query.new("SELECT uid FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1").fetch(:access_token => current_user.oauth_token)
end
def categorycount(result)
        res=[]
        categories=["Get Cultured", "Learn", "Trying New Things", "Be Merry", "Hangout with Strangers", "Laugh", "Be a Tourist", "Jam Out", "Be a Good Person", "Party Hardy", "Spend Spend Spend", "Family Channel", "Sporting Around", "Watch a Show", "Outdoor Fun", "Geeking Out"]
        categories.each do |i|
                res << [result.where(category: i).size, i]
        end
        max=0
        #need to include multiple categories, not just one if draw. fix later
        cattt=""
        res.each do |i|

                if i[0]>=max
                        cattt,max=i[1],i[0]
                end
        end
        cattt
  end

  def pricecount(result)
        #average price
        def changeval(i)
                if i=="Free!"
                        value=0
                elsif i=="<$20"
                        value= 20
                elsif i=="$20-$50"
                        value=50
                elsif i=="$50-$100"
                        value=100
                elsif i=="$100-$300"
                        value=300
                elsif i=="I don't care!"
                        value=300
                end

                value
        end
        avg=0
        result.each do |item|
                avg+=changeval(item.price)
        end

        avg=avg*1.0/result.size

  end

  def feelingscount(result)
        #refactor becasue asme as category right now
        #doesnt seem to catch them being the same
        res=[]
        feelings=["Happy", "Sad", "Celebratory", "Lonely", "Restless", "Lazy", "Excited", "Blah", "Festive", "Weird", "Nerdy", "Normal", "Fancy"]
        feelings.each do |i|
                res << [result.where(feeling: i).size, i]
        end
        max=0
        #need to include draw between categories.
        feel=""
        res.each do |val|

                if val[0]>max || max==0
                        feel,max=val,val[0]
                elsif val[0]==max

                        if result.where(feeling: val[1]).order(:created_at).first.created_at > result.where(feeling: feel).order(:created_at).first.created_at

                                feel,max=val[1],val[0]
                        end

                end
        end

        feel
        end




  def activitymap(activity)
        #might want to map all of the events for the category? not just art or cinema. but all of them,
        #and feeling allows better choice. Probably
        if activity=="Learn"
                activity=["Reading", "Museum", "Art"]#[((rand()*4)-1).ceil]
        elsif activity=="Trying New Things"
                activity="Misc."
        elsif activity=="Be Merry"
                activity="Seasonal"
        elsif activity=="Hangout with Strangers"
                activity=["Hang Out", "Misc."]#[((rand()*2)-1).ceil]
        elsif activity=="Laugh"
                activity="Comedy"
        elsif activity=="Be a Tourist"
                activity=["Gallery", "Cinema", "Theatre", "Museum", "Attraction", "Featured Park", "Garden / Conservatory"]#[((rand()*8)-1).ceil]
        elsif activity=="Outdoor Fun"
                activity=["Featured Park", "Garden / Conservatory"]#[((rand()*2)-1).ceil]
        elsif activity=="Jam Out"
                activity="Music"
        elsif activity=="Be a Good Person"
                activity="Charity"
        elsif activity=="Party Hardy"
                activity="Party"
        elsif activity=="Spend Spend Spend"
                activity="Shopping"
        elsif activity=="Family Channel"
                activity="Family"
        elsif activity=="Sporting Around"
                activity="Sport"
        elsif activity=="Geeking Out"
                activity=["Tech", "Reading"]
        elsif activity=="Watch a Show"
                activity=["Comedy", "Theatre", "Cinema", "Music"]#[((rand()*2)-1).ceil]
        elsif activity=="Get Cultured"
                activity=["Art", "Gallery", "Museum", "Cinema", "Theatre"]#[((rand()*5)-1).ceil]
        end
  end

  def feelmap(feeling)
        if feeling=="Happy"
                feelmap=[]#cannot include every event because just happy, give them based on category here
        elsif feeling=="Sad"
                feelmap=["Comedy"]
        elsif feeling=="Excited"
                feelmap=["Party", "Music"]
        elsif feeling=="Blah"
                feelmap=["Comedy"]#[((rand()*2)-1).ceil]
        elsif feeling=="Nerdy"
                feelmap=["Tech"]
        elsif feeling=="Normal"
                feelmap=["Music", "Hang Out"]#[((rand()*8)-1).ceil]
        elsif feeling=="Celebrating"
                feelmap=["Party"]#[((rand()*2)-1).ceil]
        elsif feeling=="Lonely"
                feelmap=["Hang Out"]
        elsif feeling=="Restless"
                feelmap=["Music"]
        elsif feeling=="Lazy"
                feelmap=["Hang Out"]
        elsif feeling=="Festive"
                feelmap=["Seasonal"]
        elsif feeling=="Wierd"
                feelmap=["Misc."]
        elsif feeling=="Fancy"
                feelmap=["Theatre"]
        else
                feelmap=[]
        end
  end

  def algorthim(feeling=nil,activity=nil, money=nil,recommend=false)
  	#recommend will need to pass its own feeling activity, price
  	udist=["43.6426, 79.3871"] #cannot hardcode location and time
  	if feeling==nil
  		feeling,activity,money=params[:choice1], params[:choice2], params[:choice3]
  	end #also params[geolocation]
  	if current_user && !recommend
  		current_user.choices << Choice.new({price: money,
  										category: activity,
  										feeling: feeling})
  	end
  	feelingmap=feelmap(feeling)
  	timenow=Time.now
	@data=[]
	unless recommend
		if money[/-/]
			money=money[/-\$\d+/][2..money.length]
		elsif money[/\d+/]
			money=money[/\$\d+/][1..money.length]
		else
			money=0
		end
	end
	activity=activitymap(activity)

	Event.all.each do |e|


		if e.time=="Time not listed" || Time.parse(e.time) > timenow
			if e.price =="Free" || e.price=="Price not listed" || e.price.to_f <= money.to_f

				if e.category=="Performing Arts"
					e.category="Comedy"
					e.save
				end
				if e.category==nil
					e.category="Misc."
					e.save
				end

				if e.category.count("/")==0
					if activity.include?(e.category) || feelingmap.include?(e.category) #need to penalize if come from feeling rather than category choice (doing right now by worht less)
						@data << e
					end
				else
					e.category.split("/").each do |cat|
						if activity.include?(cat) || feelingmap.include?(cat)
							@data<<e unless @data.include?(e)
						end
					end
				end
			end
		end
	end

  	respond_to do |format|
  		if recommend

  			@result, @scores=result(@data,udist, activity, "rank", feeling, feelingmap)
		  	@result=@scores.sort.reverse[0..2]
		  	return @result

  		elsif params[:button]=="try"
  			@@all=nil
			@@allprice=nil
			@@alltime=nil
			@@alldist=nil

  			format.html { redirect_to "/whattodo"}

	  	elsif params[:button]=="rank" || (params[:button]!="dist" && params[:button]!="price" && params[:button]!="pricebot" && params[:button]!="rankbot" && params[:button]!="distbot" && params[:button]!="all" && params[:button]!="try")
		  	#dont need my push method to get top three
		  	@result, @scores=result(@data,udist, activity, "rank", feeling, feelingmap)
		  	@result=@scores.sort.reverse[0..2]
			@@all=@scores

			@@all=@scores
			@@all=@scores

			@hash = Gmaps4rails.build_markers(@result) do |res, marker|
  				marker.lat Event.find_by_name(res).latitude
  				marker.lng Event.find_by_name(res).longitude
			end

	 		format.js{ render :action => "/algorthim.js.erb" }

	 	elsif params[:button]=="all"
	 		#this approach doesnt work if they do try again
	 		if params[:button2]!="dist" && params[:button2]!="price" && params[:button2]!="time"
	 			#sometimes says nil. need to fix

	 			@result=@@all.sort.reverse
	 			@button="rank"
	 			#returns [[score,event1],...]
	 			if params[:button3]

	 				@button2="down"
	 				@result=@result.reverse

	 			end

	 			format.js{ render :action => "/all.js.erb" }
	 		elsif params[:button2]=="price"
	 			if @@allprice==nil

	 				#@result, @scores=result(@data,udist,activity, "price", feeling, feelingmap)

	 				@@allprice=sorter(@data,"price")
	 			end
	 			@button=params[:button2]
	 			@result=@@allprice
	 			if params[:button3]
	 				@button2="down"

	 				@result=@result.reverse

	 			end
	 			#returns event ordered by price and no scores.
	 			#[event1,event2]

	 			format.js{ render :action => "/all.js.erb" }
	 		elsif params[:button2]=="dist"
	 			if @@alldist==nil

	 				#@result, @scores =result(@data,udist,activity, "dist", feeling, feelingmap)
	 				@@alldist=sorter(@data, "dist")
	 			end
	 			@button=params[:button2]
	 			@result=@@alldist

	 			format.js{ render :action => "/all.js.erb" }

	 			if params[:button3]
	 				@button2="down"
	 				@result=@result.reverse

	 			end

	 			format.js{ render :action => "/all.js.erb" }

	 		elsif params[:button2]=="time"
	 			if @@alltime==nil
	 				#@result, @scores =result(@data,udist,activity, "time", feeling, feelingmap)
	 				@@alltime=sorter(@data,"time")
	 			end
	 			@result=@@alltime
	 			@button=params[:button2]
	 			if params[:button3]
	 				@button2="down"
>>>>>>> 9c10d8428defc66dde8aa1fdf559acb6d8dd68e0


                                format.js{ render :action => "/all.js.erb" }
                        end
                end
         end
  end

def sorter(data, val)
        res=[]
        if val=="price"

                data=data.each{|i| i.price=1000 if i.price=="Price not listed"}
                data=data.each{|i| i.price=0 if i.price=="Free"}

                data=data.each{|i| i.price=i.price.to_i}
                sorted=data.sort{|a,b| b.price<=>a.price}.reverse

        elsif val=="time"
                #need to make into times for comparison
                data=data.each{|i| i.time="11:59 pm" if i.time=="Time not listed"}
                data=data.each{|i| i.time=Time.parse(i.time)}

                sorted=data.sort{|a,b| b.time<=>a.time}.reverse

        elsif val=="dist"
                result={}
                data.each do |item|

                        if item.longitude!=nil
                                distance=item.distance_to([43.6426, -79.3871])
                                result[item]=distance
                        else
                                result[item]=1000-rand()
                        end
                end

                sorted=result.sort_by{|k,v| v}


        end
end
def result(data, udist,activity, choice='rank', feeling, feelingmap)
        @scores={}

        data.each_with_index do |val,i|
                score=score(calculateprice(val, feeling), calculatedistance(val,udist), calculatepurity(val, activity), calculatetime(val), calculatefeeling(val,feeling, activity, udist, feelingmap)) if choice=="rank"
                score=score(calculateprice(val,true, feeling), 0, 0, 0,0) if choice=="price"
                score=score(0, calculatedistance(val,udist, true), 0, 0,0) if choice=="dist"
                score= score(0, 0, 0, calculatetime(val, true), 0) if choice=="time"
                @scores[score]=val.name
        end
        @result=[]
        return @result, @scores
end


def calculatefeeling(val, feeling, activity, udist, feelingmap)
        #doesnt work because may not get hangout with friends and still lonely
        #so should not just pick categories if match. categories selected on match
        #and feeling, so all feeling categories get into selection even if not
        #in the activity, and get a bonus
        mult=0

        if feeling=="Happy"
                mult=1 - (0.05*rand())
        elsif feeling=="Sad"
                if activity.include?("Comedy")
                        mult=1 - (0.05*rand())
                elsif activity.include?("Hang Out") || activity.include?("Comedy") || activity.include?("Charity")
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Excited"
                if activity.include?("Music")
                        mult=1 - (0.05*rand())
                elsif activity.include?("Party") || activity.include?("Sport") || activity.include?("Music")
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Blah"
                if activity.include?("Cinema")
                        mult=1 - (0.05*rand())
                elsif activity.include?("Comedy")
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Normal"
                if !(activity.include?("Misc.") || activity.include?("Charity"))
                        mult=1 - (0.05*rand())
                end
        elsif feeling=="Nerdy"
                if activity.include?("Tech")
                        mult=1 - (0.05*rand())
                elsif activity.include?("Reading") || activity.include?("Museum")
                        mult=mult=1-(0.25*rand())
                end
        elsif feeling=="Fancy"
                mult=1 - (0.05*rand())
                if val.price!="Price not listed" || val.price!="Free"
                        if val.price.to_i>=10
                                mult=1
                        end
                else (activity.include?("Museum") || activity.include?("Gallery") || activity.include?("Theatre") || activity.include?("Reading") || activity.include?("Art"))
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Celebrating" &&
                #need facebook api
                if activity.include?("Party")
                        mult=1 - (0.05*rand())
                elsif (activity.include?("Seasonal") || activity.include?("Music"))
                        mult=mult=1-(0.25*rand())
                end
        elsif feeling=="Lonely"
                if (activity.include?("Hangout"))
                #need facebook api
                        mult=1 - (0.05*rand())
                elsif activity.include?("Hangout")
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Restless"
                tnow=Time.now
                if val.time!="Time not listed"

                        if Time.parse(val.time) < 2.hours.from_now - 5.hours
                                mult=1
                        end
                elsif activity.include?("Music") || activity.include?("Music")
                        mult=1-(0.25*rand())
                end


        elsif feeling=="Lazy"
                if val.location!="Location not listed" && val.latitude!=nil

                        if val.distance_to([43.6426, -79.3871]) < 0.5
                                mult=1
                        end
                elsif activity.include?("Hang Out") || activity.include?("Hang Out")
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Festive"
                if (activity.include?("Seasonal"))
                        mult=1 - (0.05*rand())
                elsif activity.include?("Seasonal")
                        mult=1-(0.25*rand())
                end
        elsif feeling=="Wierd"
                if (activity.include?("Misc.") || activity.include?("Misc."))
                        mult=1 - (0.05*rand())
                end
        else
                mult= 0.5
        end


        mult||=0.5

        score=mult*20

end

  def calculatetime(val, full=false)
        mult=0
        time=val.time
        if time=="Time not listed"
                mult=0.01
        else
                mult=1
        end
        if full
                score=mult*100-rand()
        else
                score = mult*((33.33-29)*2)
        end
  end

  def calculateprice(val, full=false, feeling)
        price=val.price
        mult=0
        if price== "Free"
                mult=1
        elsif price=="Price not listed"
                mult=rand()
                mult=mult>=0.30 ? mult-0.22 : mult
        elsif feeling=="Fancy" && price.to_i>=10
                mult=0.9
        elsif price.to_i <= 10
                mult=0.9
        elsif price.to_i <=20
                mult=0.8
        elsif price.to_i <= 30
                mult=0.7
        elsif price.to_i <= 40
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

        if full
                score=(mult*100)-(rand()*5)
        else
                score=(mult*20)-(rand()*5)
        end

  end

  def calculatedistance(val,udist, full=nil)
        #need their ip and udist.coordinates
        #from params location, get distance from then use val.distance_from(ip address location) and find smallest distance
        if val.longitude!=nil
                distance=val.distance_to([43.6426, -79.3871]) #hardcoded
                mult=0
                if distance<=0.5
                        mult=1
                elsif distance>0.5 && distance<=1.5
                        mult=0.9
                elsif distance>1.5 && distance<=3
                        mult=0.8
                elsif distance>3 && distance<=4.5
                        mult=0.7
                elsif distance>4.5 && distance<=6
                        mult=0.6
                elsif distance>6 && distance<=7.5
                        mult=0.5
                elsif distance>7.5 && distance<=15
                        mult=0.4
                else
                        mult=0.3
                end
         else
                mult=rand()
                mult=mult>=0.30 ? mult-0.22 : mult
         end
         if full
                score=(mult*100)-rand()
         else
                score=(mult*23)-rand()
        end
  end

  def calculatepurity(val, activity)
        category=val.category.count("/")
        mult=0
        if category==0
                mult= 1
        elsif category==1
                mult= 0.9
        elsif category==2
                mult= 0.8
        elsif category==3
                mult= 0.7
        elsif category==4
                mult= 0.6
        elsif category>=5
                mult= 0.5
        else
                mult=0.4
        end
        score=mult*29

  end

  def score(val,val2,val3,val4, val5)
        val+val2+val3+val4+val5
  end


end
