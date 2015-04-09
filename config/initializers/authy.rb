puts Figaro.env.authy_key
puts ENV["AUTHY_KEY"]

Authy.api_key = Figaro.env.authy_key
Authy.api_uri = 'https://api.authy.com/'

puts Authy.api_key