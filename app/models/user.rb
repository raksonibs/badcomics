class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :images, :dependent => :destroy

  def self.adminUser
    User.find_by_email('thisbetterbeacompliment@badcomics.ca')
  end
end
