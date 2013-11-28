require 'open-uri'
require 'nokogiri'

class WelcomeController < ApplicationController
  def index
  	#@data=getdata
  end

  def getdata
		#xml=URI.parse("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")
		@doc=Nokogiri::HTML(open("http://wx.toronto.ca/festevents.nsf/tpaview?readviewentries")).xpath("//viewentry")

	end
end
