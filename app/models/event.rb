class Event < ActiveRecord::Base
	geocoded_by :location
	after_validation :geocode if :location_changed?
end
=begin
#creat task folwer with restuarnt.#!/usr/bin/env ruby -wKUnamespace :restaurants do 
											desc "set longitude long for address"
											task :update_coordiantes=> :environment do
												restaurants = Restuarant.where(longitude: nil, laittude: nil)
												restuanrs.each do |r|
													r.geocode
													r.save

	@restuarant.nearbys
=end

