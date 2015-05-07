namespace :weekly_email do
  desc 'Grabs event weekly'
  task :weekly_email => :environment do 
    @subscribers = Subscriber.all.where(subscribed: true)
    @publishedComicsThisWeek = Image.all.where(:published => true).where(comic_updated_at: (Time.now.midnight-7.days)..Time.now.midnight)
    @showThisOne = @publishedComicsThisWeek.sample
    @publishedLessShow = @publishedComicsThisWeek - [@showThisOne]
    # NTD: Easier to hsot images on s3 and not server
    hostname = "badcomics.ca"
    @subscribers.each do |subscriber|
      BadMailer.weekly_email(subscriber, hostname, @showThisOne, @publishedLessShow).deliver
    end

    puts "#{@subscribers.count} Emails went out with #{@publishedComicsThisWeek.count} comics. #{@showThisOne.title} is the image shown in the email"

  end
  

end