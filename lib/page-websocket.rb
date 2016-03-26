require './lib/model.rb'
require './lib/websocket'

class PageWebSocket < WebSocketHelper

	def initialize(ws, options = {})
		super(ws)
	end


	def on_open
		super

		UserScore.dataset.on_count_change do |scores|
			document.element('#js-status').text = "#{scores.count} records"
		end

		document.element('#js-status').text = 'ready'

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


