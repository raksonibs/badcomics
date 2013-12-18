require 'open-uri'
require 'nokogiri'
require 'active_support/core_ext/numeric/time'

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
      @recent, @installedfriends=getrecent()
    end
  end

def getrecent
  @installed=JSON.parse(open("https://graph.facebook.com/#{current_user.uid}/friends?access_token=CAAG90loE5l8BAGYHDhEUWri968ZAkwZBX5JN2SQOrK1dKPbZBWdjQ1DVIdojXBNQQ6CHNAnJ0l5sJANfERGxmZAWAfudZAEPWvjji1mL3nEyZABzvTfMW3eBgWEQHmYvOK9DbgpbzVmmMWJ8R6uehjs7ZCSRfyJKK9PPxhLCDwMR0Pq2tUFa0sgHNWz4heTkRAZD&fields=installed").read)['data']
  @true={}
  @installed.each do |friend|
    if friend["installed"]
      @true[FbGraph::User.fetch(friend["id"])]=friend["id"]
    end
  end
  @recommendations={}
  @true.each do |k,v|
    @recommendations[User.find_by_name(k.name)]=User.find_by_name(k.name).choices.last unless User.find_by_name(k.name)==nil
  end
  return @recommendations, @true
end 

def categorycount(result)
    res=[]
    categories=["Get Cultured", "Learn", "Trying New Things", "Be Merry", "Hangout with Strangers", "Laugh", "Be a Tourist", "Jam Out", "Be a Good Person", "Party Hardy", "Spend Spend Spend", "Family Channel", "Sporting Around", "Watch a Show", "Outdoor Fun", "Geeking Out"]
    categories.each do |i|
      res << [result.where(category: i).size, i]
    end
    max=0
    cattt=""
    res.each do |i|
      if i[0]>=max
        cattt,max=i[1],i[0]
      end
    end
    cattt
  end

  def pricecount(result)
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
    res=[]
    feelings=["Happy", "Sad", "Celebratory", "Lonely", "Restless", "Lazy", "Excited", "Blah", "Festive", "Weird", "Nerdy", "Normal", "Fancy"]
    feelings.each do |i|
      res << [result.where(feeling: i).size, i]
    end
    max=0
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
    if activity=="Learn"
      activity=["Reading", "Museum", "Art"]
    elsif activity=="Trying New Things"
      activity="Misc."
    elsif activity=="Be Merry"
      activity="Seasonal"
    elsif activity=="Hangout with Strangers"
      activity=["Hang Out", "Misc."]
    elsif activity=="Laugh"
      activity="Comedy"
    elsif activity=="Be a Tourist"
      activity=["Gallery", "Cinema", "Theatre", "Museum", "Attraction", "Featured Park", "Garden / Conservatory"]#[((rand()*8)-1).ceil]
    elsif activity=="Outdoor Fun"
      activity=["Featured Park", "Garden / Conservatory"]
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
      activity=["Comedy", "Theatre", "Cinema", "Music"]
    elsif activity=="Get Cultured"
      activity=["Art", "Gallery", "Museum", "Cinema", "Theatre"]
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
  	udist=["43.6426, 79.3871"] #cannot hardcode location and time
  	if feeling==nil
  		feeling,activity,money=params[:choice1], params[:choice2], params[:choice3]
  	end #also params[geolocation]
  	if current_user && !recommend && params[:button]==nil 
  		current_user.choices << Choice.new({price: money,
                      										category: activity,
                      										feeling: feeling})
  	end
  	feelingmap=feelmap(feeling)
  	timenow=Time.now
	  
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


    @data=getposs(activity,feelingmap,money, timenow)

    respondpage(@data,udist,activity,feeling,feelingmap, params, recommend)
  end

  def respondpage(data,udist,activity,feeling,feelingmap,params,recommend)
    respond_to do |format|
      if recommend
        @result, @scores=result(data,udist, activity, "rank", feeling, feelingmap)
        @result=@scores.sort.reverse[0..2]
        return @result
      elsif params[:button]=="try"
        @@all=nil
        @@allprice=nil
        @@alltime=nil
        @@alldist=nil
        format.html { redirect_to "/whattodo"}
      elsif params[:button]=="rank" || (params[:button]!="dist" && params[:button]!="price" && params[:button]!="pricebot" && params[:button]!="rankbot" && params[:button]!="distbot" && params[:button]!="all" && params[:button]!="try")
        @result, @scores=result(data,udist, activity, "rank", feeling, feelingmap)
        @result=@scores.sort.reverse[0..2]
        @@all=@scores
        if current_user && !recommend
          @choice=current_user.choices.last
          @choice.first_event=@result[0][1]
          @choice.save
        end
        @hash = Gmaps4rails.build_markers(@result) do |res, marker|
          marker.lat Event.find_by_name(res).latitude
          marker.lng Event.find_by_name(res).longitude
        end
        format.js{ render :action => "/algorthim.js.erb" }
      elsif params[:button]=="all"
       if params[:button2]!="dist" && params[:button2]!="price" && params[:button2]!="time"
          @result=@@all.sort.reverse
          @button="rank"
          if params[:button3]
            @button2="down"
            @result=@result.reverse
          end
          format.js{ render :action => "/all.js.erb" }
        elsif params[:button2]=="price"
          if @@allprice==nil
            @@allprice=sorter(data,"price")
          end
          @button=params[:button2]
          @result=@@allprice
          if params[:button3]
            @button2="down"
            @result=@result.reverse
          end
          format.js{ render :action => "/all.js.erb" }
        elsif params[:button2]=="dist"
          if @@alldist==nil
            @@alldist=sorter(data, "dist")
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
            @@alltime=sorter(data,"time")
          end
          @result=@@alltime
          @button=params[:button2]
          if params[:button3]
            @button2="down"
            @result=@result.reverse
          end
          format.js{ render :action => "/all.js.erb" }
        end
      end
    end
  end

  def getposs(activity, feelingmap, money, timenow)
    @data=[]
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
   @data

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
      elsif (activity.include?("Museum") || activity.include?("Gallery") || activity.include?("Theatre") || activity.include?("Reading") || activity.include?("Art"))
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
