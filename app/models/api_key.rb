class APIKey < ActiveRecord::Base
  before_create :generate_access_token
  
  private
  
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
      self.expires_on = Date.today + 30
    end while self.class.exists?(access_token: access_token)
  end

end
