require 'sinatra/base'
require 'sinatra/liveviews/version'

require_relative './liveviews/page-websocket'
require_relative '../sequel/sequel-extensions'

module LivePages
	def live(url, options = {}, &block)
		method_name = _method_name 'LIVE', url
		_register_callback method_name, &block
	end

	def _method_name(verb, url)
		"#{verb} #{url}".to_sym
	end

	def _register_callback(method_name, &block)
		self.send :define_method, method_name, &block
	end

	def self.registered(app)
		app.get '/sinatra/liveviews/ws' do
			return 'websockets only' if !request.websocket?

			request.websocket do |ws|
				PageWebSocket.new ws, { 
					:app => self,
					:url => params[:url] || request.referrer
				}
			end
		end

		app.get '/sinatra/liveviews.js' do
			folder = File.join File.dirname(__FILE__), './js/'
			js = ['extensions.js', 'socket.js', 'live-pages.js'].map do |file|
				path = File.join folder, file
				File.read path
			end

			return 200, {'Content-type' => 'text/javascript'}, js.join("\n")
		end
	end
end

module Sinatra
	register LivePages
end
