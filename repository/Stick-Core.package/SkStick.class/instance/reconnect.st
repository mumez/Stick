actions
reconnect
	(self isConnected or: [ self isConnecting]) ifTrue: [ ^self ].
	self endpoint reconnect