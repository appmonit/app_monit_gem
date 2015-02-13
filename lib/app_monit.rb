require "app_monit/version"
require "app_monit/errors"
require "app_monit/config"
require "app_monit/http"
require "app_monit/event"
require "app_monit/query"
require "net/https"

module AppMonit
  MUTEX = Mutex.new

  class << self
    def logger
      return @logger if @logger
      AppMonit::MUTEX.synchronize do
        return @logger if @logger
        @logger = Logger.new(STDOUT)
      end
    end
  end
end
