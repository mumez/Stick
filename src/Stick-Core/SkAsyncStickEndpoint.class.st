"
I am an SkStickEndpoint that performs sending and receiving asynchronously using dedicated background processes, so callers are not blocked on socket I/O.

Responsibility:
- I run a receiving process that loops reading from the socket stream and delivers data to my SkStick via #onDataReceived:.
- I run a sending process that loops taking byte arrays off a SharedQueue and writing them to the socket stream.
- I start/stop these processes in step with the connection lifecycle (#onConnected starts them, #close/#onReleased stop them).

Collaborators:
- SkStick: receives data via #onDataReceived: and is released if sending fails unrecoverably.
- SkSettings: supplies process priorities for the sending/receiving processes.
- SharedQueue: buffers outgoing bytes between callers of #send: and the sending process.

Public API and Key Messages:
- #send: - enqueues bytes to be written by the sending process (non-blocking).
- #start / #stop - start or request termination of the sending/receiving processes.
- #onReceiveBlock - defaults to reading the next available object from the socket stream.

Implementation Points:
- #stop signals the sending loop to end by both clearing shouldLoopSending and pushing an empty ByteArray onto the queue (to unblock a pending #next).
- #releaseProcesses forcibly terminates both processes; #shutdown runs this asynchronously at background priority to avoid blocking the caller.
"
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
