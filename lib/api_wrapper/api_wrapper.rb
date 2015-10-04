require 'httparty'
require 'json'

class ApiWrapper
  include HTTParty
  
  headers "Content-Type" => "application/x-www-form-urlencoded"
  headers "Accept" => "application/json"
  base_uri "https://api.spark.io/v1/devices/53ff6b066667574852212367/vinyl" 

  def initialize()
  end

  def replay
    # rebuild sparkcore current on get flash light
    # need to only be on and using battery when recieve signal, othewise no wifi
    # need to detect starting position. if already played and stick down, need to move stick and position arm
    # if stick up and arm not in stragiht position, need to move.
    # self.class.post("?access_token=4f986a5d4a2bae7b64804a39da2a41ccb72d297e&params=l2,HIGH")
    self.class.post("/", body: { :access_token => '4f986a5d4a2bae7b64804a39da2a41ccb72d297e', :params => 'l2,HIGH'} )
  end
end