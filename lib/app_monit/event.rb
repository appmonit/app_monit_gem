require 'json'

module AppMonit
  class Event
    def self.create(*args)
      create!(*args)
    rescue Http::Error
      false
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
        Net::HTTPHeaderSyntaxError, Net::ProtocolError, Errno::ETIMEDOUT => error
      raise error unless AppMonit::Config.fail_silent
      false
    end

    def self.create!(name, data_hash = {})
      return false unless AppMonit::Config.enabled?
      created_at = data_hash.delete(:created_at) || Time.now.utc

      message = { created_at: created_at, name: name }

      message[:api_key]     = data_hash.delete(:api_key) if data_hash[:api_key]
      message[:environment] = data_hash.delete(:environment) if data_hash[:environment]

      message[:payload] = data_hash

      post(message)
    end

    def self.post(message)
      if AppMonit::Config.async?
        AppMonit.logger.debug("[Event] push: #{message}")
        AppMonit::Worker.instance.push(message)
      else
        client.post('/v1/events', message)
      end
    end

    def self.client
      Http
    end
  end
end
