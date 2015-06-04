$:<<'lib'
require 'app_monit'

AppMonit::Config.end_point   = 'http://localhost:3000'
AppMonit::Config.api_key     = 'SOMEKEY'
AppMonit::Config.enabled     = true
AppMonit::Config.async       = false
AppMonit::Config.flush_rate  = 1
AppMonit::Config.fail_silent = true

trap(:INT) { @running = false }
@running = true
index    = 0
t        = Time.now
while @running do
  AppMonit::Event.create('test', with: 'payload', also: { nested: 'values' })
  index += 1

  # @running = index < 10

  if index == 1000
    p "Events per second: #{1000 / (Time.now - t)}"
    index = 0
    t     = Time.now
  end
end
