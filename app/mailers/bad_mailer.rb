class BadMailer < ActionMailer::Base
  default from: "thisbetterbeacompliment@badcomics.ca"

  def intro_email(subscriber)
    @subscriber = subscriber
    @subscriber.intro_sent = true
    mail(to: @subscriber.email, subject: "It's a trap!")
  end
end
