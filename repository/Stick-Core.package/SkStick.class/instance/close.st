actions
close
	self isClosed ifTrue: [ ^self ].
	self endpoint close