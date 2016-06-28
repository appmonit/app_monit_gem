module AppMonit
  class Http
    Error = Class.new(StandardError)

    SUCCESS_CODES = %w(200 201).freeze

    attr_accessor :client

    def initialize
      uri     = URI.parse(AppMonit::Config.end_point)
      @client = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        @client.use_ssl = true
        @client.verify_mode  = OpenSSL::SSL::VERIFY_PEER
      end

      @client.read_timeout = AppMonit::Config.timeout if AppMonit::Config.timeout > 0
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
      # only add Appmonit-Api-Key header if there was no api_key configured in the params
      request.add_field('Appmonit-Api-Key', AppMonit::Config.api_key) unless api_key(path)
      request.add_field('Appmonit-Env', AppMonit::Config.env)
      response = client.request(request)

      raise Error.new("Invalid response code: #{response.code} body: #{response.body}") unless SUCCESS_CODES.include?(response.code)

      response
    end

    private

    def api_key(path)
      params(path).fetch('api_key', nil)
    end

    def params(path)
      URI.decode_www_form(URI.parse(path).query).to_h
    rescue
      {}
    end
  end
end
