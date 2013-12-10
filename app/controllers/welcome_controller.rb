require 'open-uri'
require 'nokogiri'
#attractions for touristy like snakes and latteees. unique finds section?
#also want like facebook friend parties
#also funny things like sleep? maybe shouldnt tell them what to do lol
#tag based on season
#mirvish toronto
#foursquare
class WelcomeController < ApplicationController
	
  def index
  	#@data=Event.makeevents
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
  		activity=["Gallery", "Cinema", "Theatre", "Museum", "Art", "Attraction", "Featured Park", "Garden / Conservatory"]#[((rand()*8)-1).ceil]
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

  def algorthim
  	#/result/happy/art/20
  	udist=["43.6426, 79.3871"] #cannot hardcode location and time
  	feeling,activity,money=params[:choice1], params[:choice2], params[:choice3] #also params[geolocation]
  	timenow=Time.parse("Fri December 6 2013 10:00 AM")
	@data=[]
	if money[/-/]
		money=money[/-\$\d+/][2..money.length]
	elsif money[/\d+/]
		money=money[/\$\d+/][1..money.length]
	else
		money=0
	end
	activity=activitymap(activity)
	
	Event.all.each do |e|
		if e.time=="Time not listed" || Time.parse(e.time) > timenow 
			if e.price =="Free" || e.price=="Price not listed" || e.price.to_i <= money.to_i
				if e.category=="Performing Arts"
					e.category="Comedy"
					e.save
				end
				if e.category==nil
					e.category="Misc."
					e.save
				end
				if e.category.count("/")==0
					if activity.include?(e.category)
						@data << e
					end
				else
					e.category.split("/").each do |cat|
						if activity.include?(cat)
							@data<<e unless @data.include?(e)
						end
					end
				end
			end
		end
	end
	
  	respond_to do |format|
  		
	  	if params[:button]=="rank" || (params[:button]!="dist" && params[:button]!="price" && params[:button]!="pricebot" && params[:button]!="rankbot" && params[:button]!="distbot" && params[:button]!="all")
		  	@result, @scores=result(@data,udist, activity)
<<<<<<< HEAD
		  	@keys=[]
	  		@result.each do |val|
	  			@keys<< val.keys
	  		end
	  		

	  	if (@keys.flatten.size>=3)
		  	while @keys.flatten.uniq.size!=3
		  		#catches repititons
		  		@result, @scores=result(@data, udist, activity)
		  		@keys=[]
		  		@result.each do |val|
		  			@keys<< val.keys
		  		end
		  	end
		 else
		 	@result=@result
		 end
		

		  	format.js{ render :action => "/algorthim.js.erb" }
=======
		  	keys=makekeys(@result)
	 		@result= keys.flatten.uniq.size!=3 ? uniquekeys(@result,"rank", @data, udist, activity) : @result
	 		
	 		format.js{ render :action => "/algorthim.js.erb" }
>>>>>>> 9e733a29565b6a8425d5e42c49b7452d889019c9
		
		elsif params[:button]=="rankbot"
			@result, @scores=result(@data,udist, activity)
			@result=reversebot(@scores)
			format.js{ render :action => "/algorthim.js.erb" }

		elsif params[:button]=="pricebot"
			@result, @scores=result(@data,udist,activity, "price")
			@result=reversebot(@scores)
			format.js{ render :action => "/algorthim.js.erb" }
			
		elsif params[:button]=="distbot"
			@result, @scores=result(@data,udist, activity, "dist")
			@result=reversebot(@scores)
			format.js{ render :action => "/algorthim.js.erb" }

		elsif params[:button]=="price"
	 		#only prices under their choice
	 		@result, @scores =result(@data,udist,activity, "price")
	 		keys=makekeys(@result)
	 		@result= keys.flatten.uniq.size!=3 ? uniquekeys(@result,params[:button], @data, udist, activity) : @result
	 		format.js{ render :action => "/algorthim.js.erb" }


		elsif params[:button]=="dist"
	 		@result, @scores =result(@data,udist,activity, "dist")
	 		keys=makekeys(@result)
	 		@result= keys.flatten.uniq.size!=3 ? uniquekeys(@result,params[:button], @data, udist, activity) : @result

	 		format.js{ render :action => "/algorthim.js.erb" }
	 	elsif params[:button]=="all"
	 		@result, @scores=result(@data,udist, activity)
	 		@result=@scores.sort
	 		format.js{ render :action => "/all.js.erb" }

	 	end
	 	
	 end
  end

def reversebot(scores)
	result={}
	reversed=scores.sort[0..2]
	(reversed.size).times do |count|	
		result[reversed[count][1]]=reversed[count][0]
	end
	result
end

def makekeys(result)
	keys=[]
	result.each do |val|
		keys << val.keys
	end
	keys
end

def uniquekeys(result,button, data,udist, activity)

	choice="price" if button[/price/]
	choice="rank" if button[/rank/]
	choice="dist" if button[/dist/]
	keys=makekeys(result)
  	while keys.flatten.uniq.size!=3
  		#catches repititons
  		result, scores=result(data, udist, activity, choice)
		keys=makekeys(result)
	end
	result
end

def result(data, udist,activity, choice='rank')

	first={}
  	firstn=""
  	second={}
  	secondn=""
  	third={}
  	thirdn=""
  	@scores={}

  	data.each_with_index do |val,i|
  		score=score(calculateprice(val), calculatedistance(val,udist), calculatepurity(val, activity), calculatetime(val)) if choice=="rank"
  		score=score(calculateprice(val,true), 0, 0, 0) if choice=="price"
  		score=score(0, calculatedistance(val,udist, true), 0, 0) if choice=="dist"
  		@scores[score]=val.name

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
		
		if thirdn==""
			third["No 3rd place"]=0
		end
		if secondn==""
			second["No 2nd place"]=0
		end
		if firstn==""
			first["No 1st place"]=0
		end
	@result=[first,second,third]
	return @result, @scores	
end

  def calculatetime(val)
  	mult=0
  	time=val.time
  	if time=="Time not listed"
  		mult=0.01
  	else
  		mult=1
  	end
  	score =mult*((33.33-25)*2)
  end

  def calculateprice(val, full=false)
  	price=val.price
  	mult=0
  	if price== "Free"
  		mult=1
  	elsif price=="Price not listed"
  		mult=rand()
  		mult=mult>=0.30 ? mult-0.22 : mult	
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
  		score=(mult*25)-(rand()*5)
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
  		score=(mult*25)-rand()
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
  	score=mult*33.3333

  end

  def score(val,val2,val3,val4)
  	val+val2+val3+val4
  end


end


