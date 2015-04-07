<<<<<<< HEAD
puts 'Destroying all Events'
Event.destroy_all

contents = File.read('eventsseedfile.txt')
if contents == ""
  puts 'Creating Events from Seedfile'
  Event.createEvents
end

puts "Created #{Event.all.count} Events"
 
=======
case Rails.env
when "development"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca')
when "production"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca')
end
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
