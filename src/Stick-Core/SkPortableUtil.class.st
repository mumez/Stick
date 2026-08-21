"
I am the extension point for Smalltalk-dialect-specific behavior needed by Stick (socket creation, address resolution, byte/string conversion, image startup/shutdown hooks, network error detection). Concrete dialect subclasses (e.g. for Pharo or GemStone) override my hook methods; a single default instance is selected automatically.

Responsibility:
- I provide the default entry point (#default) used throughout Stick to reach dialect-specific behavior, resolving to the first registered subclass unless overridden.
- I define the interface subclasses must implement: creating socket streams, resolving addresses, converting between bytes and strings (including UTF-8), detecting network errors, and signaling exceptions.
- I hook into image startup/shutdown to notify all live SkStick instances via #onImageQuit / #onImageResume.

Collaborators:
- SkStick / SkStickEndpoint: obtain me (via SkStick>>portableUtil) to parse URLs, create sockets, resolve addresses, and signal exceptions in a dialect-appropriate way.
- Dialect-specific subclasses: override #parseUrl:, #socketStreamToHost:port:settings:, #isNetworkError:, #resolveAddress:timeout:, #utf8BytesFromString:, #stringFromUtf8Bytes:, and the startup/shutdown registration hooks.

Public API and Key Messages:
- #default - the shared instance, lazily created from #dialectSpecificClass.
- #parseUrl: - subclassResponsibility-style hook (default here returns an empty Dictionary); parses a target URL into scheme/host/port.
- #isNetworkError: - subclasses report whether a given exception represents a network-level failure that should trigger reconnection.
- #allStickInstances - all non-released SkStick instances, used for broadcasting startup/shutdown events.

Implementation Points:
- #dialectSpecificClass picks the first subclass found (self subclasses at: 1); only one dialect-specific subclass is expected to be loaded in a given image.
"
Class {
	#name : 'SkPortableUtil',
	#superclass : 'Object',
	#classVars : [
		'Default',
		'DialectSpecificClass'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'instance creation' }
SkPortableUtil class >> default [
	^Default ifNil: [Default := self dialectSpecificClass new]
]

{ #category : 'factory' }
SkPortableUtil class >> dialectSpecificClass [
	^DialectSpecificClass ifNil: [DialectSpecificClass := self subclasses at: 1]
]

{ #category : 'factory' }
SkPortableUtil class >> dialectSpecificClass: aClass [
	DialectSpecificClass := aClass
]

{ #category : 'class initialization' }
SkPortableUtil class >> initialize [
	Default := nil.
	DialectSpecificClass := nil
]

{ #category : 'startup-shutdown' }
SkPortableUtil class >> shutDown: isImageQuitting [
	^self default shutDown: isImageQuitting
]

{ #category : 'startup-shutdown' }
SkPortableUtil class >> startUp: isImageResuming [
	^self default startUp: isImageResuming
]

{ #category : 'accessing' }
SkPortableUtil >> allStickInstances [
	^SkStick allSubInstances reject: [ :each |each isReleased ]
]

{ #category : 'actions' }
SkPortableUtil >> bytesFromString: aString [
	^aString asByteArray
]

{ #category : 'factory' }
SkPortableUtil >> createMutex [
	^ Semaphore forMutualExclusion
]

{ #category : 'factory' }
SkPortableUtil >> defaultSocketStreamClassName [
	^#SocketStream
]

{ #category : 'initialize-release' }
SkPortableUtil >> initialize [
	super initialize.
	self registerAsStartupAndShutdownHandler: self class
]

{ #category : 'testing' }
SkPortableUtil >> isNetworkError: anError [
	^false

]

{ #category : 'actions' }
SkPortableUtil >> parseUrl: targetUrl [
	^Dictionary new
]

{ #category : 'startup-shutdown' }
SkPortableUtil >> registerAsStartupAndShutdownHandler: aClass [
	"override"
]

{ #category : 'actions' }
SkPortableUtil >> resolveAddress: hostName timeout: timeoutSeconds [
	^hostName
]

{ #category : 'startup-shutdown' }
SkPortableUtil >> shutDown: isImageQuitting [
	^self allStickInstances do: [ :each |  
		isImageQuitting ifTrue: [ each onImageQuit]
	]
]

{ #category : 'actions' }
SkPortableUtil >> signalException: anException [
	"Ansi"

	^anException signal
]

{ #category : 'actions' }
SkPortableUtil >> socketStreamToHost: hostIP port: portNumber settings: settings [
]

{ #category : 'startup-shutdown' }
SkPortableUtil >> startUp: isImageResuming [
	^self allStickInstances do: [ :each |  
		isImageResuming ifTrue: [ each onImageResume]
	]
]

{ #category : 'actions' }
SkPortableUtil >> stringFromUtf8Bytes: aByteArray [
	
]

{ #category : 'startup-shutdown' }
SkPortableUtil >> unregisterAsStartupAndShutdownHandler: aClass [
	"override"
]

{ #category : 'actions' }
SkPortableUtil >> utf8BytesFromString: aString [
	
]
