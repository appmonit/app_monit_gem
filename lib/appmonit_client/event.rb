require 'json'

module AppmonitClient
  class Event
    def self.create(name, data_hash = {})
      created_at = data_hash.delete(:created_at) || Time.now.utc

      message = { created_at: created_at, name: name, payload: data_hash }
      response = Http.post('/v1/events', message)

      case response.code.to_i
        when 200
          #nothing
        when 500
          Dir.mkdir('tmp') rescue Errno::EEXIST
          File.open('tmp/failed_events.log', 'a') do |f|
            f.write(message.to_json)
          end
      end
    end
  end
end
