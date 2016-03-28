var LivePageHandler = new Class({
	initialize: function() {
		var referrer_url = encodeURIComponent(document.location.href);
		this.websocket = new JSONSocket({
			url: 'ws://localhost:4567/sinatra/liveviews/ws?url=' + referrer_url,
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
