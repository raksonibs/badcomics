namespace :run_print do
  desc 'Grabs event weekly'
  task :run_print => :environment do 
    puts 'Destroying all Events'
    APIKey.create!
  end
end
