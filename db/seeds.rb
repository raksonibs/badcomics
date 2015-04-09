puts "Creating Admin User"

puts Dir.pwd

User.destroy_all
case Rails.env
when "development"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca', country_code: '1+', phone_number: '905-869-7375')
  image = Image.new(:comic => File.new('app/assets/images/comic1.png', "r"))
  User.last.images << image
  @user = User.last.save!
  authy = Authy::API.register_user(
    email: @user.email,
    cellphone: @user.phone_number,
    country_code: @user.country_code
  )
  @user.update(authy_id: authy.id)
when "production"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca', country_code: '1+', phone_number: '905-869-7375')
  image = Image.new(:comic => File.new('app/assets/images/comic1.png', "r"))
  User.last.images << image
  @user = User.last.save!
  authy = Authy::API.register_user(
    email: @user.email,
    cellphone: @user.phone_number,
    country_code: @user.country_code
  )
  user.update(authy_id: authy.id)
end

