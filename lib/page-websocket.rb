require 'sinatra/base'

require './lib/websocket'

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
		app.get '/sinatra/live-pages/ws' do
			return 'websockets only' if !request.websocket?

			request.websocket do |ws|
				PageWebSocket.new ws, { 
					:app => self,
					:url => params[:url] || request.referrer
				}
			end
		end
	end
end

module Sinatra
	register LivePages
end

class PageWebSocket < WebSocketHelper

	def initialize(ws, options = {})
		super(ws)

		# todo: validate the url and the app instances
		@app = options[:app]
		@url = options[:url]
	end

	def on_open
		super

		uri = URI.parse(@url)
		path = uri.path
		method_name = @app.class._method_name('LIVE', path)

		if @app.respond_to? method_name
			@app.send(method_name, document)
		else
			# send an error back to the client
			self.send 'message', { :content => "no live handler for #{path}" }
		end

	end

	def on_close
		super
	end

	def document
		if @document.nil?
			@document = ClientDocument.new(self)
			@document.location = @url
		end

		return @document
	end
	
end

class ClientDocument
	attr_accessor :location

	def initialize(client)
		raise 'client must be a WebSocketHelper' unless client.is_a? WebSocketHelper
		@client = client
	end

	def element(selector)
		ClientElement.new(selector, @client)
	end

	def on_load
		# maybe later we can do something else with this, but for now
		# just call the load method straight away
		yield()
	end
end

class ClientElement
	attr_accessor :selector
	
	def initialize(selector, client)
		raise 'client must be a WebSocketHelper' unless client.is_a? WebSocketHelper

		@client = client
		self.selector = selector.to_s
	end

	def execute(method, content)
		@client.send('exec', {
			:selector => self.selector,
			:method => method,
			:content => content.to_s
		})
	end

	def text=(s)
		self.execute 'text', s
	end

	def html=(s)
		self.execute 'html', s
	end

end


