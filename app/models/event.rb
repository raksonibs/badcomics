require 'open-uri'
require 'nokogiri'
require 'time'

class Event < ActiveRecord::Base
	geocoded_by :location
	after_validation :geocode if :location_changed?

  def self.getdata
  	[self.cityhall
  	]
  end
  # (name:k, time:source[k][0], price:source[k][1], 
    # location:source[k][2], category:source[k][3], 
    # link:source[k][4], feeling: "None")

  def self.cityhall
    # category split based on each new capital
  	events = []
  	data = Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")
    count = 0
    data.each do |val|
      location = val.xpath("//entrydata[@name='Location']")[count].text+ ", Toronto, ON, Canada"

      price = val.xpath("//entrydata[@name='Admission']")[count].text == "" ? "Price not listed" : val.xpath("//entrydata[@name='Admission']")[count].text
      if price[/ - /]
        price = price[/\s\$\d+/][/\d+/]
        price = price[/\d+/]
      else
        price = price == "Free" || price == "Price not listed" ? price : price[/\d+/]
      end

      categoryList = val.xpath("//entrydata[@name='CategoryList']")[count].text
      # annoying regex to check for categoryList
      categoryList = if categoryList == nil 
                        "Misc" 
                      else
                        categoryList.split(/([A-Z]+[a-z]*\s*[a-z]*)/).reject! { |c| c.empty? || c == "/"}
                      end

      timeStart = val.xpath("//entrydata[@name='TimeBegin']")[count].text == "" || val.xpath("//entrydata[@name='TimeBegin']")[count].text == nil || val.xpath("//entrydata[@name='TimeBegin']")[count].text == ': ' ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeBegin']")[count].text).strftime("%I:%M %p")
      timeEnd = val.xpath("//entrydata[@name='TimeEnd']")[count].text == "" || val.xpath("//entrydata[@name='TimeBegin']")[count].text == nil || val.xpath("//entrydata[@name='TimeBegin']")[count].text == ': ' ? "Time not listed" : Time.parse(val.xpath("//entrydata[@name='TimeEnd']")[count].text).strftime("%I:%M %p")

      url = val.xpath("//entrydata[@name='EventURL']")[count].text == "" || val.xpath("//entrydata[@name='EventURL']")[count].text == nil ? "No url listed" : val.xpath("//entrydata[@name='EventURL']")[count].text
      # day start and end used for ranges
      events.push({name: val.xpath("//entrydata[@name='EventName']")[count].text, 
                  price: price,
                  dayOn: val.xpath("//entrydata[@name='DateBeginShow']")[count].text,
                  dayEnd: val.xpath("//entrydata[@name='DateEndShow']")[count].text,
                  startTime: timeStart,
                  endTime: timeEnd,
                  location: location,
                  desc: val.xpath("//entrydata[@name='LongDesc']")[count].text,
                  eventUrl: url,
                  categories: categoryList
                })
      count += 1
    end

    return events
  end

end
