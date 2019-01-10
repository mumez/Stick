private
handleNetworkError
	self onClosed.
	[ self stick reconnect ] fork