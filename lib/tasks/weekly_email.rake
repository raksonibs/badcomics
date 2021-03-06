namespace :weekly_email do
  desc 'Grabs event weekly'
  task :weekly_email => :environment do 
    @subscribers = Subscriber.all.where(subscribed: true)
    order_images = Image.all.where(:published => true).order('comic_updated_at')
    @published = order_images[-3..-1]
    @showThisOne = @published.sample
    @publishedLessShow = @published - [@showThisOne]
    @publishedComicsLastWeek = order_images[-6..-4]
    @publishedLastWeek = @publishedComicsLastWeek.first
    # NTD: Easier to hsot images on s3 and not server
    hostname = "badcomics.ca"
    @subscribers.each do |subscriber|
      BadMailer.weekly_email(subscriber, hostname, @showThisOne, @published, @publishedLastWeek).deliver
    end

    puts "#{@subscribers.count} Emails went out with #{@published.count} comics."

  end

  desc 'Grabs event weekly'
  task :test_weekly_email => :environment do 
    @subscribers = Subscriber.where(email: 'oskarniburski@gmail.com')
    order_images = Image.all.where(:published => true).order('comic_updated_at')
    @published = order_images[-3..-1]
    @showThisOne = @published.sample
    @publishedLessShow = @published - [@showThisOne]
    @publishedComicsLastWeek = order_images[-6..-4]
    @publishedLastWeek = @publishedComicsLastWeek.first
    # NTD: Easier to hsot images on s3 and not server
    hostname = "badcomics.ca"
    @subscribers.each do |subscriber|
      BadMailer.weekly_email(subscriber, hostname, @showThisOne, @published, @publishedLastWeek).deliver
    end

    puts "#{@subscribers.count} Emails went out with #{@published.count} comics."

  end

  desc 'Sends store email'
  task :store_email => :environment do 
    @subscribers = Subscriber.all.where(subscribed: true)
    @products = Product.all
    hostname = "badcomics.ca"
    @subscribers.each do |subscriber|
      BadMailer.store_email(subscriber, hostname, @products).deliver
    end

    puts "#{@subscribers.count} Emails went out."

  end
  

end