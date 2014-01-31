require 'json'

module AppmonitClient
  class Event
    def self.create(data_hash)
      http                     = Net::HTTP.new(AppmonitClient::Config.end_point)
      #http.set_debug_output $stdout
      request                  = Net::HTTP::Post.new('/events')

      # set headers so event data ends up in the correct bucket on the other side
      request.add_field("Appmonit-Api-Key", AppmonitClient::Config.api_key)
      request.add_field("Appmonit-Env", AppmonitClient::Config.env)

      request.content_type = 'application/json'
      request.body = { created_at: Time.now.utc }.merge(data_hash).to_json
      response = http.request(request)
      # TODO check response.code and/or response.body
    end
  end
end
