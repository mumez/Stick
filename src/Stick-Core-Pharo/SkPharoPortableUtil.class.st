Class {
	#name : 'SkPharoPortableUtil',
	#superclass : 'SkPortableUtil',
	#category : 'Stick-Core-Pharo',
	#package : 'Stick-Core-Pharo'
}

{ #category : 'factory' }
SkPharoPortableUtil >> createMutex [
	^ Mutex new
]

{ #category : 'factory' }
SkPharoPortableUtil >> defaultSocketStreamClassName [
	^#ZdcSocketStream
]

{ #category : 'testing' }
SkPharoPortableUtil >> isNetworkError: anError [
	^anError isKindOf: NetworkError
]

{ #category : 'actions' }
SkPharoPortableUtil >> parseUrl: targetUrl [
	| dict url |
	dict := super parseUrl: targetUrl.
	url := targetUrl asUrl.
	dict at: #scheme put: url scheme.
	dict at: #host put: url host.
	dict at: #port put: url port.
	url username ifNotNil: [:n | dict at: #username put: n  ].
	url password ifNotNil: [:p | dict at: #password put: p  ]. 
	^dict
	
	
]

{ #category : 'startup-shutdown' }
SkPharoPortableUtil >> registerAsStartupAndShutdownHandler: aClass [
	SessionManager default
		registerNetworkClassNamed: aClass name
]

{ #category : 'actions' }
SkPharoPortableUtil >> resolveAddress: hostName timeout: timeoutSeconds [
	 ^ NetNameResolver addressForName: hostName timeout: timeoutSeconds.
]

{ #category : 'actions' }
SkPharoPortableUtil >> socketStreamToHost: hostIP port: portNumber settings: settings [
	Smalltalk globals at: settings socketStreamClassName ifPresent: [ :cls |
		^ cls openConnectionToHost: hostIP port: portNumber timeout: settings connectionTimeoutSeconds
	 ].
	^nil
]

{ #category : 'actions' }
SkPharoPortableUtil >> stringFromUtf8Bytes: aByteArray [
	^aByteArray decodeWith: #utf8
	
]

{ #category : 'startup-shutdown' }
SkPharoPortableUtil >> unregisterAsStartupAndShutdownHandler: aClass [
	SessionManager default
		unregisterClassNamed: aClass name
]

{ #category : 'actions' }
SkPharoPortableUtil >> utf8BytesFromString: aString [
	^aString encodeWith: #utf8
]
