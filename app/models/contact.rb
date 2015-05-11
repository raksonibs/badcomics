class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "You contacted Bad Comics",
      :to => "thisbetterbeacompliment@badcomics.ca",
      :from => %("#{name}" <#{email}>)
    }
  end
end