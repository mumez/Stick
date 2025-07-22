Class {
	#name : 'SkReconnectEnded',
	#superclass : 'SkError',
	#instVars : [
		'endpoint'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'instance creation' }
SkReconnectEnded class >> endpoint: anEndpoint [
	^self new endpoint: anEndpoint 
]

{ #category : 'accessing' }
SkReconnectEnded >> endpoint [
	^ endpoint
]

{ #category : 'accessing' }
SkReconnectEnded >> endpoint: anObject [
	endpoint := anObject
]

{ #category : 'testing' }
SkReconnectEnded >> isReconnectEnded [
	^true
]

{ #category : 'printing' }
SkReconnectEnded >> printDetailsOn: aStream [
	super printDetailsOn: aStream.
	aStream space.
	self endpoint printOn: aStream
]
