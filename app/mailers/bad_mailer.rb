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
    mail(to: @subscriber.email, subject: "It's a trap!")
  end
end
