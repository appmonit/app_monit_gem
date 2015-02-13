$:<<'lib'
require 'app_monit'

AppMonit::Config.end_point  = 'http://localhost:3000'
AppMonit::Config.api_key    = 'SOMEKEY'
AppMonit::Config.enabled    = true
AppMonit::Config.async      = true
AppMonit::Config.flush_rate = 1

AppMonit::Event.create('test', with: 'payload')

AppMonit.logger.debug 'Press enter to exit'
gets
