Class {
	#name : 'SkAsyncStickEndpoint',
	#superclass : 'SkStickEndpoint',
	#instVars : [
		'sendQueue',
		'sendingProcess',
		'shouldLoopSending',
		'receivingProcess'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'actions' }
SkAsyncStickEndpoint >> close [
	super close.
	self releaseProcesses.
]

{ #category : 'factory' }
SkAsyncStickEndpoint >> defaultOnReceiveBlock [
	^[:sock | sock next]
]

{ #category : 'initialize-release' }
SkAsyncStickEndpoint >> initialize [
	super initialize.
	sendQueue := SharedQueue new
]

{ #category : 'private' }
SkAsyncStickEndpoint >> loopReceiving [
	[ self shouldLoopReceiving ] whileTrue: [ self receiveData ].
	self shutdown 
]

{ #category : 'private' }
SkAsyncStickEndpoint >> loopSending [
	[ self shouldLoopSending ] whileTrue: [ self sendData ].
	self shutdown 
]

{ #category : 'event handling' }
SkAsyncStickEndpoint >> onClosed [
	self stop.
	self stick onClosed.
	
]

{ #category : 'event handling' }
SkAsyncStickEndpoint >> onConnected [
	self start.
	super onConnected
]

{ #category : 'event handling' }
SkAsyncStickEndpoint >> onDataReceived: data [
	self stick onDataReceived: data
]

{ #category : 'accessing' }
SkAsyncStickEndpoint >> onReceiveBlock [
	^ onReceiveBlock ifNil: [ onReceiveBlock := self defaultOnReceiveBlock ]
]

{ #category : 'event handling' }
SkAsyncStickEndpoint >> onReleased [
	self stop.
	super onReleased
]

{ #category : 'receiving' }
SkAsyncStickEndpoint >> receiveData [
	| sockStream bytes |
	self shouldEndReconnecting ifTrue: [ ^self stick release ].
	sockStream := self socketStream ifNil: [ self waitFor: 3. ^self ].
	sockStream isConnected ifFalse: [ self waitFor: 3 ].
	self errorHandlingDo: [ 
		[bytes := self onReceiveBlock value: sockStream] on: ConnectionTimedOut do: [:ex | self logger debug: ex ]
	].
	bytes ifNotNil: [ self onDataReceived: bytes]
]

{ #category : 'initialize-release' }
SkAsyncStickEndpoint >> release [
	super release.
	self shutdown
]

{ #category : 'initialize-release' }
SkAsyncStickEndpoint >> releaseProcesses [
	shouldLoopSending := false.
	sendingProcess ifNotNil: [sendingProcess terminate.  sendingProcess := nil ].
	receivingProcess ifNotNil: [receivingProcess terminate.  receivingProcess := nil ].
	
]

{ #category : 'actions' }
SkAsyncStickEndpoint >> send: bytes [
	self errorHandlingDo: [self sendQueue nextPut:  bytes]
]

{ #category : 'sending' }
SkAsyncStickEndpoint >> sendData [
	self socketStream
		ifNotNil:
			[ :sockStream | self errorHandlingDo: [ self sendDataBy: sockStream ] ]
]

{ #category : 'sending' }
SkAsyncStickEndpoint >> sendDataBy: aSocketStream [
	aSocketStream isConnected ifFalse: [ ^self ].
	[aSocketStream nextPutAll: self sendQueue next.
	aSocketStream flush] on: Error do: [ :ex | self stick release ]
]

{ #category : 'accessing' }
SkAsyncStickEndpoint >> sendQueue [
	^sendQueue ifNil: [ sendQueue := SharedQueue new ]
]

{ #category : 'accessing' }
SkAsyncStickEndpoint >> shouldLoopReceiving [
	^ self shouldLoopSending
]

{ #category : 'accessing' }
SkAsyncStickEndpoint >> shouldLoopSending [
	^ shouldLoopSending ifNil: [ shouldLoopSending := true ]
]

{ #category : 'initialize-release' }
SkAsyncStickEndpoint >> shutdown [
	[self releaseProcesses.
	sendQueue ifNotNil: [sendQueue flush].
	sendQueue := nil] forkAt: Processor userBackgroundPriority 
]

{ #category : 'start/stop' }
SkAsyncStickEndpoint >> start [
	self startSendingProcess.
	self startReceivingProcess.
]

{ #category : 'start/stop' }
SkAsyncStickEndpoint >> startReceivingProcess [
	receivingProcess notNil ifTrue: [
		receivingProcess isTerminating ifFalse: [ receivingProcess terminate ]
	].
	receivingProcess := [self loopReceiving] newProcess.
	receivingProcess priority: self settings receivingProcessPriority.
	receivingProcess resume.
]

{ #category : 'start/stop' }
SkAsyncStickEndpoint >> startSendingProcess [
	sendingProcess notNil ifTrue: [
		sendingProcess isTerminating ifFalse: [ sendingProcess terminate ]
	].
	shouldLoopSending := true.
	sendingProcess := [self loopSending] newProcess.
	sendingProcess priority: self settings sendingProcessPriority.
	sendingProcess resume.
]

{ #category : 'start/stop' }
SkAsyncStickEndpoint >> stop [
	self sendQueue nextPut: #[].
	shouldLoopSending := false.
]
