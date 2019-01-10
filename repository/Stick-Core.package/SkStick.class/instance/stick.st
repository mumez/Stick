reconnecting
stick
	self isReleased ifTrue: [ ^self close ].
	self endpoint reset.
	self connect