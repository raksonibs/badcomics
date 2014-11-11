puts 'Destroying all Events'
Event.destroy_all

contents = File.read('eventsseedfile.txt')
if contents == ""
  puts 'Creating Events from Seedfile'
  Event.createEvents
end

puts "Created #{Event.all.count} Events"
 
