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
