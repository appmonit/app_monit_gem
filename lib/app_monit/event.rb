require 'json'

module AppMonit
  class Event
    def self.create(*args)
      create!(*args)
    rescue Http::Error
      false
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
        Net::HTTPHeaderSyntaxError, Net::ProtocolError => error
      raise error unless AppMonit::Config.fail_silent
      false
    end

    def self.create!(name, data_hash = {})
      return false unless AppMonit::Config.enabled?
      created_at = data_hash.delete(:created_at) || Time.now.utc

      message = { created_at: created_at, name: name, payload: data_hash }
      client.post('/v1/events', message)
    end

    def self.client
      Http
    end
  end
end
