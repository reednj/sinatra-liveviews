require './lib/websocket'

class PageWebSocket < WebSocketHelper

	def initialize(ws, options = {})
		super(ws)
	end


	def on_open
		super

		self.send 'ok'
	end

	def on_close
		super
	end
	

end


