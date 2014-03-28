require 'app_monit'
require 'minitest/autorun'
require 'minitest/unit'
#require 'minitest/pride'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

require 'webmock/minitest'
