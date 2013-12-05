namespace :events do 
	desc "set longitude long for address"
	task :update_coordinates=> :environment do
		events = Event.where(longitude: nil, latitude: nil)
		events.each do |r|
			r.geocode
			r.save
		end
	end
end