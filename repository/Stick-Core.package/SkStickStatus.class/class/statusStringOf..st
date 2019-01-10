printing
statusStringOf: aNumber
	aNumber = self initial ifTrue: [ ^'initial' ].
	aNumber = self connecting ifTrue: [ ^'connecting' ].
	aNumber = self connected ifTrue: [ ^'connected' ].
	aNumber = self closing ifTrue: [ ^'closing' ].
	aNumber = self closed ifTrue: [ ^'closed' ].
	aNumber = self released ifTrue: [ ^'released' ].
	aNumber = self ended ifTrue: [ ^'ended' ].
	^'unknown'