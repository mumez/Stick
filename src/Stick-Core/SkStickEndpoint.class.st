Class {
	#name : 'SkStickEndpoint',
	#superclass : 'Object',
	#instVars : [
		'remoteHost',
		'remotePortNumber',
		'socketStream',
		'onReceiveBlock',
		'stick',
		'reconnectMutex',
		'reconnectTrials',
		'reconnectIntervalSeconds'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'instance creation' }
SkStickEndpoint class >> on: aStick [
	^self new on: aStick; yourself
]

{ #category : 'actions' }
SkStickEndpoint >> basicConnect [

	| ipAddr connected |
	(self stick isConnected and: [ self socketIsConnected ]) ifTrue: [
		^ true ].
	self stick onConnecting.
	ipAddr := self errorHandlingDo: [
		          self portableUtil
			          resolveAddress: self remoteHost
			          timeout: self settings nameResolveTimeoutSeconds ].
	ipAddr ifNil: [
		self stick onConnectFailed.
		^ false ].
	connected := self connectTo: ipAddr port: self remotePortNumber.
	connected ifFalse: [ self stick onConnectFailed ].
	^ connected
]

{ #category : 'actions' }
SkStickEndpoint >> close [
	self onClosing.
	self socketClose.
	self onClosed
	
]

{ #category : 'actions' }
SkStickEndpoint >> connect [
	self socketIsConnected ifTrue: [ ^true ].
	^ self reconnectMutex critical: [  
		self basicConnect
	]
	
]

{ #category : 'actions' }
SkStickEndpoint >> connectTo: ipAddr port: portNum [
	self stick isConnected ifTrue: [ ^self ].
	socketStream := self errorHandlingDo: [ self createSocketStreamToHost: ipAddr port: portNum].
	socketStream ifNil: [ ^ false ].
	self onConnected.
	^ true
]

{ #category : 'factory' }
SkStickEndpoint >> createMutex [
	^ self portableUtil createMutex
]

{ #category : 'factory' }
SkStickEndpoint >> createSocketStreamToHost: ipAddr port: portNum [
	^self portableUtil socketStreamToHost: ipAddr port: portNum settings: self settings
]

{ #category : 'private' }
SkStickEndpoint >> errorHandlingDo: aBlock [
	^self errorHandlingDo: aBlock returning: []
]

{ #category : 'private' }
SkStickEndpoint >> errorHandlingDo: aBlock returning: returnBlock [
	^[aBlock value] on: Error do: [ :ex | self onErrorSignaled: ex. returnBlock value]
]

{ #category : 'private' }
SkStickEndpoint >> handleNetworkError [
	self onClosed.
	[ self stick reconnect ] fork
]

{ #category : 'private' }
SkStickEndpoint >> incrementReconnectTrials [
	^reconnectTrials := reconnectTrials + 1
]

{ #category : 'accessing' }
SkStickEndpoint >> logger [
	^self stick logger
]

{ #category : 'private' }
SkStickEndpoint >> nextReconnectIntervalSeconds [
	^ reconnectIntervalSeconds := reconnectIntervalSeconds * self settings reconnectIncrementRatio 
]

{ #category : 'initialization-release' }
SkStickEndpoint >> on: aStick [
	stick := aStick.
	self reset
]

{ #category : 'event handling' }
SkStickEndpoint >> onClosed [
	self stick onClosed.
	
]

{ #category : 'event handling' }
SkStickEndpoint >> onClosing [
	self stick onClosing.
	
]

{ #category : 'event handling' }
SkStickEndpoint >> onConnected [
	self stick onConnected.
	self reset
]

{ #category : 'event handling' }
SkStickEndpoint >> onDataReceived: data [
]

{ #category : 'event handling' }
SkStickEndpoint >> onErrorSignaled: anError [
	self stick isReleased ifTrue: [^self].
	self logger error: anError.
	(self portableUtil isNetworkError: anError)
		ifTrue: [self handleNetworkError ]
		ifFalse: [ self stick onErrorSignaled: anError ]
]

{ #category : 'event handling' }
SkStickEndpoint >> onReceive: aBlock [
	onReceiveBlock := aBlock
]

{ #category : 'accessing' }
SkStickEndpoint >> onReceiveBlock [
	^ onReceiveBlock
]

{ #category : 'event handling' }
SkStickEndpoint >> onReleased [
	"Callback when stick was released."
	self release
]

{ #category : 'accessing' }
SkStickEndpoint >> portableUtil [
	^self stick portableUtil
]

{ #category : 'printing' }
SkStickEndpoint >> printDetailsOn: aStream [
	self remoteHost ifNotNil: [aStream nextPutAll: self remoteHost asString].
	self remotePortNumber ifNotNil: [aStream nextPut: $:; nextPutAll: self remotePortNumber  asString]
]

{ #category : 'printing' }
SkStickEndpoint >> printOn: aStream [
	aStream nextPutAll: self class name, '('.
	self printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : 'actions' }
SkStickEndpoint >> reconnect [
	self socketIsConnected ifTrue: [ ^true ].
	self reconnectMutex critical: [  
		self incrementReconnectTrials.
		self shouldEndReconnecting ifTrue: [
			^ self errorHandlingDo: [(SkReconnectEnded endpoint: self) signal]
	 	].
		self waitFor: (self nextReconnectIntervalSeconds).
		self basicConnect.
	]
]

{ #category : 'accessing' }
SkStickEndpoint >> reconnectMutex [
	^reconnectMutex ifNil: [ reconnectMutex := self createMutex ]
]

{ #category : 'accessing' }
SkStickEndpoint >> reconnectTrials [
	^reconnectTrials ifNil: [ reconnectTrials := 0 ]
]

{ #category : 'initialization-release' }
SkStickEndpoint >> release [
	super release.
	self socketClose.
	self reset.
	
]

{ #category : 'accessing' }
SkStickEndpoint >> remoteHost [
	^ remoteHost
]

{ #category : 'accessing' }
SkStickEndpoint >> remoteHost: anObject [
	remoteHost := anObject
]

{ #category : 'accessing' }
SkStickEndpoint >> remotePortNumber [
	^ remotePortNumber
]

{ #category : 'accessing' }
SkStickEndpoint >> remotePortNumber: anObject [
	remotePortNumber := anObject
]

{ #category : 'initialization-release' }
SkStickEndpoint >> reset [
	reconnectTrials := 0.
	reconnectIntervalSeconds := self settings reconnectIntervalSeconds
]

{ #category : 'actions' }
SkStickEndpoint >> send: bytes [
	self subclassResponsibility
]

{ #category : 'accessing' }
SkStickEndpoint >> settings [
	^self stick settings
]

{ #category : 'testing' }
SkStickEndpoint >> shouldEndReconnecting [
	^self reconnectTrials > self settings maxReconnects
]

{ #category : 'private' }
SkStickEndpoint >> socketClose [
	socketStream ifNil: [^self].
	[socketStream close] on: NetworkError do: [:ex | self logger error: ex].
	self logger info: 'Sticking socket closed: ', socketStream printString.
	socketStream := nil
]

{ #category : 'testing' }
SkStickEndpoint >> socketIsConnected [
	self socketStream ifNil: [ ^false ].
	^ self socketStream isConnected
]

{ #category : 'accessing' }
SkStickEndpoint >> socketStream [
	^ socketStream
]

{ #category : 'accessing' }
SkStickEndpoint >> socketStream: anObject [
	socketStream := anObject
]

{ #category : 'accessing' }
SkStickEndpoint >> stick [
	^ stick
]

{ #category : 'accessing' }
SkStickEndpoint >> stick: anObject [
	stick := anObject
]

{ #category : 'accessing' }
SkStickEndpoint >> targetUrl [
	^self stick targetUrl
]

{ #category : 'private' }
SkStickEndpoint >> waitFor: seconds [
	(Delay forSeconds: (seconds)) wait.
	self logger info: 'Sticking endpoint waits: ',  seconds asString
]
