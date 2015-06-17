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
  

end