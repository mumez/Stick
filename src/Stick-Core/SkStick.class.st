Class {
	#name : 'SkStick',
	#superclass : 'Object',
	#instVars : [
		'targetUrl',
		'endpoint',
		'settings',
		'onErrorBlock',
		'onConnectedBlock',
		'onClosedBlock',
		'onDataBlock',
		'status',
		'logger'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'releasing' }
SkStick class >> releaseAll [
	<script>
	self allSubInstances do: [ :e | e release ]
]

{ #category : 'instance creation' }
SkStick class >> targetUrl: targetUrl [
	| inst |
	inst := self basicNew.
	inst targetUrl: targetUrl.
	inst initialize.
	^inst
]

{ #category : 'reconnecting' }
SkStick >> beSticky [
	self onError: [:ex | ex isReconnectEnded ifTrue: [self stick]].
]

{ #category : 'reconnecting' }
SkStick >> beSwitchy: newTargetUrlBlock [
	self
		onError: [ :ex | 
			ex isReconnectEnded
				ifTrue: [ self switch: (newTargetUrlBlock cull: self) ] ]
]

{ #category : 'reconnecting' }
SkStick >> beSwitchyWithAll [
	self beSwitchyWithAll: self settings switchingTargetUrls
]

{ #category : 'reconnecting' }
SkStick >> beSwitchyWithAll: switchingUrls [
	switchingUrls ifEmpty: [ ^self releaseThenConnect].
	self beSwitchy: [ :ignore | | index |
		index := (switchingUrls indexOf: self targetUrl).
		switchingUrls atWrap: index + 1.
	]
	
]

{ #category : 'actions' }
SkStick >> close [
	self isClosed ifTrue: [ ^self ].
	self endpoint close
]

{ #category : 'actions' }
SkStick >> connect [
	self isEnded ifTrue: [ ^self ].
	(self isConnected or: [ self isConnecting]) ifTrue: [ ^self ].
	self endpoint connect
]

{ #category : 'factory' }
SkStick >> createEndpoint [
	| dict endpointClass ep |
	dict := 	self portableUtil parseUrl: self targetUrl.
	endpointClass := self endpointClassForScheme: (dict at: #scheme ifAbsent: [ ]).
	endpointClass ifNil: [ self portableUtil signalException: (SkUnsupportedUrlScheme new) ].
	ep := endpointClass on: self.
	ep remoteHost: (dict at: #host ifAbsent: [ ]).
	ep remotePortNumber: (dict at: #port ifAbsent: [ ]).
	^ep
]

{ #category : 'defaults' }
SkStick >> defaultErrorHandingBlock [
	^[:ex | self logger error: ex]
]

{ #category : 'defaults' }
SkStick >> defaultLogger [
	^SkLocalLogger new
]

{ #category : 'initialize-release' }
SkStick >> destroy [
	self release.
	status := SkStickStatus ended
]

{ #category : 'accessing' }
SkStick >> endpoint [
	^ endpoint ifNil: [ endpoint := self createEndpoint ]
]

{ #category : 'accessing' }
SkStick >> endpoint: anObject [
	endpoint := anObject
]

{ #category : 'factory' }
SkStick >> endpointClassForScheme: schemeName [
	schemeName ifNil: [ ^nil ].
	(schemeName beginsWith:  'sync') ifTrue: [ ^SkSyncStickEndpoint ].
	^SkAsyncStickEndpoint 
]

{ #category : 'initialize-release' }
SkStick >> initEndpoint [
	endpoint := self createEndpoint
]

{ #category : 'initialize-release' }
SkStick >> initialize [
	status := SkStickStatus initial.
	self initEndpoint
]

{ #category : 'testing' }
SkStick >> isClosed [
	^self status = SkStickStatus closed
]

{ #category : 'testing' }
SkStick >> isConnected [
	^self status = SkStickStatus connected
]

{ #category : 'testing' }
SkStick >> isConnecting [
	^self status = SkStickStatus connecting 
]

{ #category : 'testing' }
SkStick >> isEnded [
	^self status = SkStickStatus ended
]

{ #category : 'testing' }
SkStick >> isReleased [
	^self status = SkStickStatus released
]

{ #category : 'accessing' }
SkStick >> logger [
	^ logger ifNil: [ logger := self defaultLogger ]
]

{ #category : 'accessing' }
SkStick >> logger: aLogger [
	 logger := aLogger
]

{ #category : 'event-handling' }
SkStick >> onClosed [
	status := SkStickStatus closed.
	self onClosedBlock ifNotNil: [ :block | block cull: self ]
]

{ #category : 'event-handling' }
SkStick >> onClosed: aBlock [
	onClosedBlock := aBlock
]

{ #category : 'accessing' }
SkStick >> onClosedBlock [
	^ onClosedBlock
]

{ #category : 'event-handling' }
SkStick >> onClosing [
	status := SkStickStatus closing.
]

{ #category : 'event-handling' }
SkStick >> onConnectFailed [
	status := SkStickStatus initial.
]

{ #category : 'event-handling' }
SkStick >> onConnected [
	status := SkStickStatus connected.
	self onConnectedBlock ifNotNil: [ :block | block cull: self ]
]

{ #category : 'event-handling' }
SkStick >> onConnected: aBlock [
	onConnectedBlock := aBlock
]

{ #category : 'accessing' }
SkStick >> onConnectedBlock [
	^ onConnectedBlock
]

{ #category : 'event-handling' }
SkStick >> onConnecting [
	status := SkStickStatus connecting.
]

{ #category : 'event-handling' }
SkStick >> onData: aBlock [
	onDataBlock := aBlock
]

{ #category : 'accessing' }
SkStick >> onDataBlock [
	^ onDataBlock
]

{ #category : 'event-handling' }
SkStick >> onDataReceived: data [
	self onDataBlock ifNotNil: [ :block | block value: data ]
]

{ #category : 'event-handling' }
SkStick >> onError: aBlock [
	onErrorBlock := aBlock
]

{ #category : 'accessing' }
SkStick >> onErrorBlock [
	^ onErrorBlock ifNil: [ onErrorBlock := self defaultErrorHandingBlock]
]

{ #category : 'event-handling' }
SkStick >> onErrorSignaled: anException [
	self onErrorBlock ifNotNil: [ :block | block cull: anException cull: self]
]

{ #category : 'startup-shutdown' }
SkStick >> onImageQuit [
]

{ #category : 'startup-shutdown' }
SkStick >> onImageResume [
]

{ #category : 'event-handling' }
SkStick >> onReceive: aBlock [
	self endpoint onReceive: aBlock
]

{ #category : 'accessing' }
SkStick >> portableUtil [
	^SkPortableUtil default
]

{ #category : 'printing' }
SkStick >> printOn: aStream [
	aStream nextPutAll: self className.
	aStream nextPutAll: ' (' , self statusString , ')'.
	endpoint
		ifNotNil: [ aStream nextPutAll: ' - '.
			endpoint printOn: aStream ]
]

{ #category : 'actions' }
SkStick >> reconnect [
	(self isConnected or: [ self isConnecting]) ifTrue: [ ^self ].
	self endpoint reconnect
]

{ #category : 'initialize-release' }
SkStick >> release [
	self isReleased ifTrue: [^self].
	status := SkStickStatus released.
	endpoint ifNotNil: [endpoint onReleased].
	endpoint := nil
]

{ #category : 'reconnecting' }
SkStick >> releaseThenConnect [
	self release.
	self endpoint waitFor: self releaseThenConnectIntervalSeconds.
	self connect
]

{ #category : 'accessing' }
SkStick >> releaseThenConnectIntervalSeconds [
	^self settings reconnectIntervalSeconds // 2
]

{ #category : 'sending' }
SkStick >> send: aByteArray [
	self endpoint send: aByteArray
]

{ #category : 'accessing' }
SkStick >> settings [
	^ settings ifNil: [settings := SkSettings default ]
]

{ #category : 'accessing' }
SkStick >> settings: anObject [
	settings := anObject
]

{ #category : 'accessing' }
SkStick >> status [
	^status
]

{ #category : 'printing' }
SkStick >> statusString [
	^SkStickStatus statusStringOf: self status
]

{ #category : 'reconnecting' }
SkStick >> stick [
	self isReleased ifTrue: [ ^self close ].
	self endpoint reset.
	self connect
]

{ #category : 'reconnecting' }
SkStick >> switch: newTargetUrl [
	self targetUrl: newTargetUrl.
	self releaseThenConnect
]

{ #category : 'accessing' }
SkStick >> targetUrl [
	^ targetUrl
]

{ #category : 'accessing' }
SkStick >> targetUrl: anObject [
	targetUrl := anObject
]
