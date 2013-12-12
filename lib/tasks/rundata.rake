
desc "Get events"
task :getdata => :environment do
	
	Event.makeevents
	
end