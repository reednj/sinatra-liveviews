require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/content_for'
require 'sinatra/json'

require 'json'
require 'erubis'

require "sinatra/reloader" if development?

require './lib/model'
require './lib/extensions'
require './lib/page-websocket'

use Rack::Deflater
set :erb, :escape_html => true
set :version, 'v0.1'

configure :development do
	also_reload './lib/model.rb'
	also_reload './lib/extensions.rb'
	also_reload './lib/page-websocket.rb'
end

configure :production do

end

helpers do

	# basically the same as a regular halt, but it sends the message to the 
	# client with the content type 'text/plain'. This is important, because
	# the client error handlers look for that, and will display the message
	# if it is text/plain and short enough
	def halt_with_text(code, message = nil)
		message = message.to_s if !message.nil?
		halt code, {'Content-Type' => 'text/plain'}, message
	end

end

get '/' do
	redirect to('/admin/stats')
end

get '/admin/stats' do
	erb :home, :layout => :_layout
end

live '/admin/stats' do |document|

	document.on_load do
		document.element('#js-count').text = 'ready'
	end

	UserScore.where(:user_id => 1).on_count_change do |scores|
		document.element('#js-count').text = "#{scores.count} records"
		document.element('#js-sum').text = "total: #{scores.sum(:score).round}"
		document.element('#js-avg').text = "avg: #{scores.avg(:score).round(2)}"
	end
end
