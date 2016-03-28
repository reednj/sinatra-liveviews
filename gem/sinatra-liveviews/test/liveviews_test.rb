ENV['RACK_ENV'] = 'development'

require 'rubygems'
require 'minitest/autorun'
require 'rack/test'
require 'test/unit'

require_relative './app'

class LiveViewsTest < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end


end

