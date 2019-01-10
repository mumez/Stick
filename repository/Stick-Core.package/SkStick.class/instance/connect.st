actions
connect
	self isEnded ifTrue: [ ^self ].
	(self isConnected or: [ self isConnecting]) ifTrue: [ ^self ].
	status := SkStickStatus connecting.
	self endpoint connect