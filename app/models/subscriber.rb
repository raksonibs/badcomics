class Subscriber < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validate :correct_email

  def correct_email
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "is not an email")
    end
  end

end
