module AppmonitClient
  class ApiKeyNotSetError < RuntimeError
    def message
      "Please set your API key, see http://appmon.it/help/set_api_key for more info."
    end
  end
end
