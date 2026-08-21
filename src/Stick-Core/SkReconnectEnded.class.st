"
I am the SkError signaled by an SkStickEndpoint when its reconnect attempts have been exhausted (trial count exceeds the configured maximum). Handlers can catch me to decide what happens next, e.g. give up, switch target URL, or retry from scratch.

Responsibility:
- I identify myself as a reconnect-ended condition via #isReconnectEnded (true here, false by default on Exception).
- I reference the SkStickEndpoint whose reconnection attempts failed.

Collaborators:
- SkStickEndpoint: signals me from #reconnect once #shouldEndReconnecting is true.
- SkStick: typically installs an #onError: handler that checks #isReconnectEnded to trigger #stick (retry) or #switch: (change target URL).

Public API and Key Messages:
- #endpoint: - class-side factory taking the endpoint that gave up reconnecting.
- #isReconnectEnded - answers true, distinguishing me from other errors in generic error handlers.
"
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
