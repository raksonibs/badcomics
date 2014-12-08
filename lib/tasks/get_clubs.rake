namespace :get_clubs do
  desc 'Grabs event weekly'
  task :get_clubs => :environment do 

    puts 'Adding clubs and not deleting old ones'
    Event.club_crawler_create

    puts "Created #{Event.all.count} Events"
  end
end
