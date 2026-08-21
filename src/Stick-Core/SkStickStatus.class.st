"
I am a namespace of class-side constants representing the possible lifecycle states of an SkStick (initial, connecting, connected, closing, closed, released, ended), plus a helper to render a status code as a human-readable string. I am not instantiated.

Responsibility:
- I define the canonical integer value for each SkStick status.
- I convert a status value back to a descriptive string for printing/debugging.

Collaborators:
- SkStick: stores one of my constants in its #status instance variable and uses my values in #isConnected, #isClosed, #isEnded, etc.

Public API and Key Messages:
- #initial / #connecting / #connected / #closing / #closed / #released / #ended - the status constants.
- #statusStringOf: - answers the string name for a given status value ('unknown' if unrecognized).
"
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
