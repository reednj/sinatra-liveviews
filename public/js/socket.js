
if(typeof WebSocket === 'undefined') {
	// if websockets are not supported, then we just create
	// a dummy one that does nothing, but gives no errors	
	WebSocket = new Class({
		initialize: function() {},
		send: function() {}
	});
}


var JSONSocket = new Class({
	initialize: function(options) {
		this.options = options || {};
		this.options.url = this.options.url || null;
		this.options.onOpen = this.options.onOpen || function() {};
		this.options.onClose = this.options.onClose || function() {};

		this.options.autoreconnect = this.options.autoreconnect === false ? false : true;
		this.options.autoconnect = this.options.autoconnect === false ? false : true;
		this.options.connectWait = 1;

		this._stats = {in: 0, out: 0};

		if(this.options.autoconnect) {
			this.initSocket();
		}
	},

	initSocket: function() {
		this.ws = new WebSocket(this.options.url);
		this.ws.onopen = this.onOpen.bind(this);
		this.ws.onclose = this.onClose.bind(this);
		this.ws.onmessage = function(e) {
			this.onMessage(JSON.parse(e.data));
		}.bind(this);
	},
	
	onOpen: function() {
		this.options.connectWait = 1;
		this.options.onOpen(this, this.ws);
	},
	
	onClose: function() {
		this.options.onClose(this, this.ws);

		if(this.options.autoreconnect === true) {
			this.open.delay(this.options.connectWait * 1000, this);
			this.options.connectWait *= 2;
			this.options.connectWait = this.options.connectWait.limit(1, 30);
		}
	},
	
	onMessage: function(msg) {
		if(msg.event && typeof msg.event == 'string') {
			this._stats.in++;
			(this.eventNameToFunction(msg.event))(msg.data);
		}
	},
	
	send: function(eventType, data) {
		if(this.isConnected()) {
			var str = JSON.encode({event: eventType, data: data});
			this.ws.send(str);
			this._stats.out++;
		}
	},

	addEvents: function(events) {
		Object.each(events, function(fn, eventType) {
			this.addEvent(eventType, fn);
		}.bind(this));

		return this;
	},

	addEvent: function(eventType, fn) {
		
		if(eventType && typeof fn == 'function') {
			var fnName = 'on_' + eventType;
			
			if(!this.options[fnName]) {
				this.options[fnName] = fn;
			} else if(typeof this.options[fnName] == 'function') {
				var currentFn = this.options[fnName];
				this.options[fnName] = function() {
					currentFn.apply(this, arguments);
					fn.apply(this, arguments);
				};
			}
		}

		return this;
	},

	eventNameToFunction: function(eventType) {
		if(eventType) {
			var fnName = 'on_' + eventType;
			return this.options[fnName] || (function() {});
		}
	},

	isConnected: function() {
		WebSocket.OPEN = WebSocket.OPEN || 1; // turns out not all browsers define the state consts
		return this.ws && this.ws.readyState === WebSocket.OPEN;
	},

	close: function() {
		this.options.autoreconnect = false;
		this.ws.close();
	},

	open: function() {
		this.initSocket();
	},

	stats: function() {
		return this._stats;
	}
});
