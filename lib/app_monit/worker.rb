module AppMonit
  class Worker
    MUTEX          = Mutex.new
    MAX_MULTIPLIER = 5

    attr_accessor :events

    class << self
      def instance
        return @instance if @instance
        MUTEX.synchronize do
          return @instance if @instance
          @instance = new.start
        end
      end
    end

    def initialize
      @queue      = Queue.new
      @multiplier = 1
      @flush_rate = AppMonit::Config.flush_rate
      reset
    end

    def reset
      @events      = []
      @allow_flush = true
    end

    def start
      logger.debug('Start collecting')
      Thread.new do
        AppMonit.logger.debug('Waiting for queue')
        while (event = @queue.pop)
          begin
            case event
              when :flush
                @allow_flush = true
                send_to_collector
              else
                logger.debug 'Received event'
                events << event
                if @allow_flush && events.count > 10
                  send_to_collector
                end
            end
          rescue Exception => e
            logger.debug ['Event error:', event.inspect, e.message]
            @allow_flush = false
          end
        end
      end
      start_flusher

      self
    end

    def start_flusher
      Thread.new do
        loop do
          sleep @multiplier * @flush_rate
          push(:flush)
        end
      end
    end

    def push(event)
      @queue << event
    end

    def logger
      AppMonit.logger
    end

    def send_to_collector
      if @events.any?
        logger.debug 'Sending to collector'
        AppMonit::Http.post('/v1/events', event: events)
      end
      reset
    end
  end
end
