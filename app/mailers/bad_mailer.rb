class BadMailer < ActionMailer::Base
  default from: "thisbetterbeacompliment@badcomics.ca"

  layout 'mailer'

  def intro_email(subscriber, hostname)
    @subscriber = subscriber
    @subscriber.intro_sent = true
    if Rails.env.development?
      @hostname = "http://localhost:3000" 
    else
      @hostname = "http://badcomics.ca" 
    end
    mail(to: @subscriber.email, subject: "Welcome, here's a gif-t")
  end

  def store_email(subscriber, hostname, products)
    @subscriber = subscriber
    @products = products

    @cups = Product.find_by_name("Hic-cup")
    @clown_shirt = Product.find_by_name('Clown Shirt')
    @goose_shirt = Product.find_by_name('Goose Shirt')
    if Rails.env.development?
      @hostname = "http://localhost:3000" 
    else
      @hostname = "http://badcomics.ca" 
    end
    mail(to: @subscriber.email, subject: "The Bad Comics Store!!!!!!!")
  end

  def test_weekly_email(subscriber, hostname, showThisOne, published, lastWeekComic)
    @showThisOne = showThisOne
    @publishedLastWeek = lastWeekComic
    @published = published
    @subscriber = subscriber
    if Rails.env.development?
      @hostname = "http://localhost:3000" 
    else
      @hostname = "http://badcomics.ca" 
    end
    mail(to: @subscriber.email, subject: "The Good Stuff at Bad Comics")
    redirect_to :weekly_email
  end

  def contact_to_us(user)
    @contact = user
    mail(to:  "thisbetterbeacompliment@badcomics.ca", subject: 'We were contacted!')
  end

  def weekly_email(subscriber, hostname, showThisOne, published, lastWeekComic)
    @showThisOne = showThisOne
    @publishedLastWeek = lastWeekComic
    @published = published
    @subscriber = subscriber
    if Rails.env.development?
      @hostname = "http://localhost:3000" 
    else
      @hostname = "http://badcomics.ca" 
    end
    mail(to: @subscriber.email, subject: "The Good Stuff at Bad Comics")
  end
end
