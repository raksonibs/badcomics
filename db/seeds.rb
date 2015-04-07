puts "Creating Admin User"

puts Dir.pwd

User.destroy_all
case Rails.env
when "development"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca')
  image = Image.new(:comic => File.new('app/assets/images/comic1.png', "r"))
  User.last.images << image
  User.last.save!
when "production"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca')
  image = Image.new(:comic => File.new('app/assets/images/comic1.png', "r"))
  User.last.images << image
  User.last.save!
end

