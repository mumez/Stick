Class {
	#name : 'SkStickStatus',
	#superclass : 'Object',
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'constants' }
SkStickStatus class >> closed [
	^3
]

{ #category : 'constants' }
SkStickStatus class >> closing [
	^2
]

{ #category : 'constants' }
SkStickStatus class >> connected [
	^1
]

{ #category : 'constants' }
SkStickStatus class >> connecting [
	^0
]

{ #category : 'constants' }
SkStickStatus class >> ended [
	^-3
]

{ #category : 'constants' }
SkStickStatus class >> initial [
	^-1
]

{ #category : 'constants' }
SkStickStatus class >> released [
	^-2
]

{ #category : 'printing' }
SkStickStatus class >> statusStringOf: aNumber [
	aNumber = self initial ifTrue: [ ^'initial' ].
	aNumber = self connecting ifTrue: [ ^'connecting' ].
	aNumber = self connected ifTrue: [ ^'connected' ].
	aNumber = self closing ifTrue: [ ^'closing' ].
	aNumber = self closed ifTrue: [ ^'closed' ].
	aNumber = self released ifTrue: [ ^'released' ].
	aNumber = self ended ifTrue: [ ^'ended' ].
	^'unknown'
]
