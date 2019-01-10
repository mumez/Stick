reconnecting
beSticky
	self onError: [:ex | ex isReconnectEnded ifTrue: [self stick]].