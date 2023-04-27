actions
connect
	self isEnded ifTrue: [ ^self ].
	(self isConnected or: [ self isConnecting]) ifTrue: [ ^self ].
	self endpoint connect