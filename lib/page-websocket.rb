require './lib/websocket'

class PageWebSocket < WebSocketHelper

	def initialize(ws, options = {})
		super(ws)
	end


	def on_open
		super

		self.send('exec', {
			:selector => '#js-status',
			:method => 'text',
			:content => 'text from server'
		})

	end

	def on_close
		super
	end
	

end


