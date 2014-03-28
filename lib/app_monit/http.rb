module AppMonit
  class Http
    Error = Class.new(StandardError)

    SUCCESS_CODES = %w(200 201).freeze

    def self.post(path, data_hash)
      request :post, path, data_hash
    end

    def self.get(path)
      request :get, path
    end

    def self.request(method, path, body = nil)
      uri  = URI.parse(AppMonit::Config.end_point)
      http = Net::HTTP.new(uri.host, uri.port)

      if method == :get
        request = Net::HTTP::Get.new(path)
      else
        request              = Net::HTTP::Post.new(path)
        request.body         = body.to_json if body
        request.content_type = 'application/json'
      end

      # set headers so event data ends up in the correct bucket on the other side
      request.add_field('Appmonit-Api-Key', AppMonit::Config.api_key)
      request.add_field('Appmonit-Env', AppMonit::Config.env)
      response = http.request(request)

      raise Error.new unless SUCCESS_CODES.include?(response.code)

      response
    end

    private

    def self.create_query_string(hash)
      hash.collect do |key, value|
        value.to_query("event[#{key}]")
      end.sort! * '&'
    end
  end
end
