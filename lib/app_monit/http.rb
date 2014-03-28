module AppMonit
  class Http
    Error = Class.new(StandardError)

    SUCCESS_CODES = %w(200 201).freeze

    attr_accessor :client

    def initialize
      uri     = URI.parse(AppMonit::Config.end_point)
      @client = Net::HTTP.new(uri.host, uri.port)

      @client.read_timeout = 1
    end

    def self.post(path, data_hash)
      request :post, path, data_hash
    end

    def self.get(path)
      request :get, path
    end

    def self.request(*args)
      new.request(*args)
    end

    def request(method, path, body = nil)
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
      response = client.request(request)

      raise Error.new unless SUCCESS_CODES.include?(response.code)

      response
    end
  end
end
