module AppMonit
  class Config
    class << self
      attr_writer :api_key, :env, :end_point, :fail_silent, :enabled, :timeout, :version, :async, :log_level

      def api_key
        @api_key || raise(ApiKeyNotSetError.new("Please set your API key"))
      end

      def env
        @env || "development"
      end

      def end_point
        @end_point || "https://api.appmon.it"
      end

      def version
        @version || "v1"
      end

      def fail_silent
        @fail_silent || false
      end

      def enabled?
        @enabled.nil? ? env != "test" : @enabled
      end

      def log_level
        @log_level || Logger::DEBUG
      end

      def async?
        @async
      end

      def timeout
        @timeout || 1
      end
    end
  end
end
