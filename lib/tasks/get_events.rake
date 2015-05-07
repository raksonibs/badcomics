namespace :get_events do
  desc 'Grabs event weekly'
  task :get_events => :environment do 
    puts 'Destroying all Events'
    Event.destroy_all

    puts 'Creating Events'
    Event.createEvents

    puts "Created #{Event.all.count} Events"
  end
end

# namespace :weekly_email do
#   Subscriber.all.where(subscri)
# end