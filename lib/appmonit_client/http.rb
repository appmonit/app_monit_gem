module AppmonitClient
  class Http
    def self.post(path, data_hash)
      request :post, path, data_hash
    end

    def self.get(path, data_hash)
      request :get, path, data_hash
    end

    def self.request(method, path, data_hash)
      uri = URI.parse(AppmonitClient::Config.end_point)
      http    = Net::HTTP.new(uri.host, uri.port)
      #http.set_debug_output $stdout
      if method == :get
        request = Net::HTTP::Get.new(path)
      else
        request = Net::HTTP::Post.new(path)
      end

      # set headers so event data ends up in the correct bucket on the other side
      request.add_field('Appmonit-Api-Key', AppmonitClient::Config.api_key)
      request.add_field('Appmonit-Env', AppmonitClient::Config.env)

      request.content_type = 'application/json'
      request.body = data_hash.to_json

      http.request(request)
    end
  end
end
