
case Rails.env
when "development"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca')
when "production"
  User.create!(name: 'BadAdmin', password: 'ihatepies12', email: 'thisbetterbeacompliment@badcomics.ca')
end

