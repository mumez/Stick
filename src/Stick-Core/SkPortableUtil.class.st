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
