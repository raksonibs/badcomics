require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  # has_attached_file :comic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  # validates_attachment_content_type :comic, :content_type => /\Aimage\/.*\Z/

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end