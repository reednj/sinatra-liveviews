require './lib/websocket'

class PageWebSocket < WebSocketHelper

	def initialize(ws, options = {})
		super(ws)
	end


	def on_open
		super

		self.element('#js-status').text = '<i>hello</i>'

	end

	def on_close
		super
	end

	def element(selector)
		ClientElement.new(selector, self)
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


