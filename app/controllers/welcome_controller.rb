require 'open-uri'
require 'nokogiri'
#attractions for touristy
#also want like facebook friend parties
#also funny things like sleep? maybe shouldnt tell them what to do lol
#tag based on season
#mirvish toronto
#foursquare
class WelcomeController < ApplicationController
	@@called={Date.today.strftime("%B %01d, %Y")=>false}
	#doesn't work when close browser. need to do the script thing
	@@result=nil

	def index
  	#makeevents unless @@called[Date.today.strftime("%B %01d, %Y")]
  	respond_to do |format|
  		
  		if params[:button]=="Lazy"
  			
  			
  			@data=Event.near([params[:latitude],params[:longitude]],1, :units => :km)

  			format.js{}
  		else
  			@@result=request.location
  			@cat=[]
  			Event.all.each_with_index do |e,i|
  				@cat<<e.category if !(@cat.include?(e.category))
  				
  			end
  			format.html{ @data=Event.all }
  		end
  	end
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
	#want to make better loop
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
				#if (activity=="Garden / Conservatory" && e.category[/#{activity}/] ) || (activity=="Hang Out" && e.category[/#{activity}/] ) || (activity=="Featured Park" && e.category[/#{activity}/] )|| e.category[/#{activity.capitalize}/]
					
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
  		
	  	if params[:button]=="rank" || (params[:button]!="dist" && params[:button]!="price")
		  	@result, @scores=result(@data,udist, activity)
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
		
	

		elsif params[:button]=="price"
	 		#only prices under their choice
	 		@result, @scores =resultprice(@data,udist,activity)
	 		@keys=[]
	   		@result.each do |val|
	   			@keys<< val.keys
	   		end
	 	  	while @keys.flatten.uniq.size!=3
	 	  		#catches repititons
	 	  		@result, @scores=resultdis(@data, udist, activity)
	 	  		@keys=[]
		  		@result.each do |val|
		  			@keys<< val.keys
		  		end
		  	end

	 	  	format.js{ render :action => "/algorthim.js.erb" }
	 	
			
		
		elsif params[:button]=="dist"
			

	 		@result, @scores =resultdis(@data,udist,activity)
	 		@keys=[]
	   		@result.each do |val|
	   			@keys<< val.keys
	   		end
	 	  	while @keys.flatten.uniq.size!=3
	 	  		#catches repititons
	 	  		@result, @scores=resultdis(@data, udist, activity)
	 	  		@keys=[]
		  		@result.each do |val|
		  			@keys<< val.keys
		  		end
		  	end

	 	  	format.js{ render :action => "/algorthim.js.erb" }
	 	end
	
	 end
	# @result
  end


	def resultdis(data, udist,acitivty)
	#right now doing closest
		first={}
	  	firstn=""
	  	second={}
	  	secondn=""
	  	third={}
	  	thirdn=""
	  	@scores=[]
	  	data.each_with_index do |val,i|
	  		score=score(0, calculatedistance(val,udist, true), 0, 0)
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
		if thirdn==""
			third["No 3rd place"]=0
		end
		if secondn==""
			second["No 2nd place"]=0
		end

		@result=[first,second,third]
		
		return @result, @scores	


	end

	def resultprice(data, udist,acitivty)
	#right now doing closest
		first={}
	  	firstn=""
	  	second={}
	  	secondn=""
	  	third={}
	  	thirdn=""
	  	@scores=[]
	  	data.each_with_index do |val,i|
	  		score=score(calculateprice(val,true), 0, 0, 0)
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
		if thirdn==""
			third["No 3rd place"]=0
		end
		if secondn==""
			second["No 2nd place"]=0
		end

		@result=[first,second,third]
		
		return @result, @scores	


	end

def result(data, udist,activity)
	first={}
  	firstn=""
  	second={}
  	secondn=""
  	third={}
  	thirdn=""
  	@scores=[]
  	data.each_with_index do |val,i|
  		score=score(calculateprice(val), calculatedistance(val,udist), calculatepurity(val, activity), calculatetime(val))
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
	return @result, @scores	
end


  def calculatetime(val)
  	mult=0
  	time=val.time


  	if time=="Time not listed"
  		mult=rand()
  		mult=mult<=0.23 ? mult : mult-0.22
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
  		mult=mult<=0.23 ? mult : mult-0.22
  		
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
  		score=mult*100
  	else
  		score=mult*25
  	end


  end

  def calculatedistance(val,udist, full=nil)
  	#need their ip and udist.coordinates
  	#from params location, get distance from then use val.distance_from(ip address location) and find smallest distance
  	if val.longitude!=nil
  		
  		distance=val.distance_to([43.6426, -79.3871]) #hardcoded

  		mult=0
	  	if distance<=1
	  		mult=1-rand()
	  	elsif distance>1 && distance<=3
	  		mult=0.80-rand()
	  	elsif distance>3 && distance<=6
	  		mult=0.6-rand()
	  	elsif distance>6 && distance<=10
	  		mult=0.4-rand()
	  	elsif distance>10 && distance<=15
	  		mult=0.2-rand()
	  	elsif distance>15 && distance<=25
	  		mult=0.1-rand()
	  	else
	  		mult=0
	  	end
	 else
	 	mult=rand()
	 	mult=mult<=0.23 ? mult : mult-0.22
	 end
	 if full
	 	score=mult*100
	 else
  		score=mult*25
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


