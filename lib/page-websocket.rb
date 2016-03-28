require 'sinatra/base'

require './lib/model.rb'
require './lib/websocket'

module LivePages
	def live(url, options = {}, &block)
		method_name = _method_name 'LIVE', url
		_register_callback method_name, &block

	end

	def _method_name(verb, url)
		# "#{verb} #{url}".to_sym
		:live_page_callback
	end

	def _register_callback(method_name, &block)
		self.send :define_method, method_name, &block
	end

	def self.registered(app)
		app.get '/sinatra/live-pages/ws' do
			return 'websockets only' if !request.websocket?

			request.websocket do |ws|
				PageWebSocket.new ws, { 
					:app => self
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
		@app = options[:app]
		@url = options[:url]
	end

	def on_open
		super

		@app.live_page_callback(document)

		#UserScore.dataset.on_count_change do |scores|
		#	document.element('#js-count').text = "#{scores.count} records"
		#	document.element('#js-sum').text = "total: #{scores.sum(:score).round}"
		#	document.element('#js-avg').text = "avg: #{scores.avg(:score).round(2)}"
		#end

	end

	def on_close
		super
	end

	def document
		@document = ClientDocument.new(self) if @document.nil?
		return @document
	end
	
end

class ClientDocument
	def initialize(client)
		raise 'client must be a WebSocketHelper' unless client.is_a? WebSocketHelper
		@client = client
	end

	def element(selector)
		ClientElement.new(selector, @client)
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


