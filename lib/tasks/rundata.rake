
desc "Get events"
task :getdata => :environment do
	
	Event.makedata
	
end