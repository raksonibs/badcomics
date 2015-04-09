puts Figaro.env.auth_key
puts ENV["AUTHY_KEY"]

Authy.api_key = puts Figaro.env.auth_key
Authy.api_uri = 'https://api.authy.com/'

puts Authy.api_key