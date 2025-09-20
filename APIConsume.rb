require "httparty"

class APIConsume

  attr_accessor :base_uri

  def initialize(base_uri)

    @base_uri = base_uri

  end
  
  def tracks(limit)

    response = HTTParty.get(@base_uri + "tracks?per_page=#{limit}&audio_stats=complete")
    return response

  end 

end