require 'httparty'
require 'json'

class ApiWrapper
  include HTTParty
  
  headers "Content-Type" => "application/json"
  headers "Accept" => "application/json"
  base_uri "https://api.spark.io/v1/devices/53ff6b066667574852212367/replay" 

  def initialize()
  end

  def replay
    # rebuild sparkcore current on get flash light
    # need to only be on and using battery when recieve signal, othewise no wifi
    # need to detect starting position. if already played and stick down, need to move stick and position arm
    # if stick up and arm not in stragiht position, need to move.
    
    self.class.get("/", :body => { :access_token => Figaro.env.access_token}.to_json )
  end
end