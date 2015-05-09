require 'uri'
require 'net/http'

puts "Creating Admin User"

puts Dir.pwd

User.destroy_all
case Rails.env
when "development"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca', country_code: '1', phone_number: '9055162020')
  image = Image.new(:comic => File.new('app/assets/images/Cake_1.jpg', "r"))
  image.title = "Cake"
  image.order = 1
  image.published = true
  User.last.images << image
  User.last.save!
  @user = User.last
  authy = Authy::API.register_user(
    email: @user.email,
    cellphone: @user.phone_number,
    country_code: @user.country_code
  )
  if authy == {}
    params = {'email' => 'thisbetterbeacompliment@badcomics.ca', 'cellphone' => '9055162020', 'country_code' => '1'}
    x = Net::HTTP.post_form(URI.parse('https://api.authy.com/protected/json/users/new?api_key='+Figaro.env.authy_key), params)
    puts x.body
  else
    @user.update(authy_id: authy.id)
  end
when "production"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca', country_code: '1', phone_number: '9055162020')
  image = Image.new(:comic => File.new('app/assets/images/Cake_1.jpg', "r"))
  image.title = "Cake"
  image.order = 1
  image.published = true
  User.last.images << image
  User.last.save!
  @user = User.last
  authy = Authy::API.register_user(
    email: @user.email,
    cellphone: @user.phone_number,
    country_code: @user.country_code
  )
  if authy == {}
    params = {'email' => 'thisbetterbeacompliment@badcomics.ca', 'cellphone' => '9055162020', 'country_code' => '1'}
    x = Net::HTTP.post_form(URI.parse('https://api.authy.com/protected/json/users/new?api_key='+Figaro.env.authy_key), params)
    puts x.body
  else
    @user.update(authy_id: authy.id)
  end
end

