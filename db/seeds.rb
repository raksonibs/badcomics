require 'uri'
require 'net/http'

puts "Creating Admin User"

def seed_image(file_name)
  File.open(File.join(Rails.root, "/app/assets/images/#{file_name}"))
end

puts Dir.pwd
if Subscriber.all.count <= 0
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
end

Product.destroy_all
@product_one = Product.new({name: 'Shirt', colour: 'White', description: 'This is a great shirt, buy it', price: 100, product_image: seed_image('babies.png')}).save
@product_two = Product.new({name: 'Umbrella', colour: 'Black', description: 'For males and females', price: 50, product_image: seed_image('car.png')}).save
@product_three = Product.new({name: 'Cups', colour: nil, description: 'Drink blood', price: 250, product_image: seed_image('bigcastle.jpg')}).save
@product_four = Product.new({name: 'Poster', colour: nil, description: 'Basically a large, stickyless post-it note with stuff already scribbled on it', price: 10, product_image: seed_image('growingup.png')}).save
@product_five = Product.new({name: 'Festival Custom Card', colour: nil, description: 'Custom stuff', price: 30, product_image: seed_image('mickeymouse.png')}).save
@product_six = Product.new({name: 'Birthday Card', colour: nil, description: 'Custom stuff', price: 2, product_image: seed_image('smallcastle.jpg')}).save


