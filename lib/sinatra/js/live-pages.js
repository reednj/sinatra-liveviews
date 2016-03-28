var LivePageHandler = new Class({
	initialize: function() {
		var referrer_url = encodeURIComponent(document.location.href);
		var socket_url = JSONSocket.websocketUrlForPath('/sinatra/liveviews/ws');

		this.websocket = new JSONSocket({
			url: socket_url + '?url=' + referrer_url,
			on_exec: function(data) {
				$(data.selector)[data.method](data.content);
			},

			on_message: function(data) {
				console.log('live pages: ' + data.content);
			}

		});
	}
});

$(document).ready(function() {
	window._live_page_handler = new LivePageHandler();
});
