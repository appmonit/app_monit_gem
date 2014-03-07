require 'json'

module AppmonitClient
  class Event
    def self.create(data_hash)
      response = Http.post('/events', { created_at: Time.now.utc }.merge(data_hash).to_json)
      # TODO check response.code and/or response.body
    end
  end
end
