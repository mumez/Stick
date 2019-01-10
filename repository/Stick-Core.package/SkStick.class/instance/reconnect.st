actions
reconnect
	(self isConnected or: [ self isConnecting]) ifTrue: [ ^self ].
	status := SkStickStatus connecting.
	self endpoint reconnect