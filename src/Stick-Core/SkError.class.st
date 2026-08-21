"
I am the base exception class for errors signaled within Stick. I carry a symbolic ""kind"" plus arbitrary extra info, and optionally reference the SkStick instance involved, so handlers can distinguish and react to different failure categories.

Responsibility:
- I identify the category of error via #kind (defaulting to my class name if not set).
- I hold #otherInfo, a Dictionary for arbitrary diagnostic details.
- I optionally reference the SkStick that was active when I was signaled.

Collaborators:
- SkStick: errors are routed to its #onErrorBlock via #onErrorSignaled:.
- Subclasses (e.g. SkReconnectEnded, SkUnsupportedUrlScheme): represent specific error conditions.

Public API and Key Messages:
- #kind: / #kind: otherInfo: - class-side factories for creating an instance with a given kind.
- #stick / #stick: - access the associated SkStick.
- #otherInfo - lazily initialized Dictionary of extra details.
"
Class {
	#name : 'SkError',
	#superclass : 'Error',
	#instVars : [
		'stick',
		'kind',
		'otherInfo'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'instance creation' }
SkError class >> kind: aSymbol [ 
	^ self kind: aSymbol otherInfo: nil
]

{ #category : 'instance creation' }
SkError class >> kind: aSymbol otherInfo: otherInfo [
	^ self new
		kind: aSymbol;
		otherInfo: otherInfo;
		yourself
]

{ #category : 'defaults' }
SkError >> defaultKind [
	^self className
]

{ #category : 'accessing' }
SkError >> kind [
	^ kind
]

{ #category : 'accessing' }
SkError >> kind: anObject [
	kind := anObject
]

{ #category : 'accessing' }
SkError >> otherInfo [
	^ otherInfo ifNil: [ otherInfo := Dictionary new ]
]

{ #category : 'accessing' }
SkError >> otherInfo: anObject [
	otherInfo := anObject
]

{ #category : 'printing' }
SkError >> printDetailsOn: aStream [
	self kind ifNotNil: [aStream nextPutAll: self kind asString].
	self otherInfo ifNotEmpty: [aStream space; nextPutAll: self otherInfo asString]
]

{ #category : 'printing' }
SkError >> printOn: aStream [
	aStream nextPutAll: self class name, '('.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : 'accessing' }
SkError >> stick [
	^ stick
]

{ #category : 'accessing' }
SkError >> stick: anObject [
	stick := anObject
]
