module AppMonit
  class Config
    class << self
      attr_writer :api_key, :env, :end_point

      def api_key
        @api_key || raise(ApiKeyNotSetError.new("Please set your API key"))
      end

      def env
        @env || "development"
      end

      def end_point
        @end_point || "http://api.appmon.it"
      end
    end
  end
end
