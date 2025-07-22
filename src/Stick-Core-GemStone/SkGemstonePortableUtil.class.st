Class {
	#name : 'SkGemstonePortableUtil',
	#superclass : 'SkPortableUtil',
	#category : 'Stick-Core-GemStone',
	#package : 'Stick-Core-GemStone'
}

{ #category : 'factory' }
SkGemstonePortableUtil >> createMutex [
	^ TransientMutex new
]

{ #category : 'factory' }
SkGemstonePortableUtil >> defaultSocketStreamClassName [
	^#ZdcSocketStream
]

{ #category : 'testing' }
SkGemstonePortableUtil >> isNetworkError: anError [
	^anError isKindOf: NetworkError
]

{ #category : 'actions' }
SkGemstonePortableUtil >> parseUrl: targetUrl [
  | dict url |
  dict := super parseUrl: targetUrl.
  url := ZnUrl fromString: targetUrl.
  dict at: #'scheme' put: url scheme.
  dict at: #'host' put: url host.
  dict at: #'port' put: url port.
  url username ifNotNil: [ :n | dict at: #'username' put: n ].
  url password ifNotNil: [ :p | dict at: #'password' put: p ].
  ^ dict
]

{ #category : 'startup-shutdown' }
SkGemstonePortableUtil >> registerAsStartupAndShutdownHandler: aClass [
  "override"


]

{ #category : 'actions' }
SkGemstonePortableUtil >> resolveAddress: hostName timeout: timeoutSeconds [
  ^ GsSocket getHostAddressByName: hostName
]

{ #category : 'actions' }
SkGemstonePortableUtil >> socketStreamToHost: hostIP port: portNumber settings: settings [
	Smalltalk globals at: settings socketStreamClassName ifPresent: [ :cls |
		^ cls openConnectionToHost: hostIP port: portNumber timeout: settings connectionTimeoutSeconds
	 ].
	^nil
]

{ #category : 'actions' }
SkGemstonePortableUtil >> stringFromUtf8Bytes: aByteArray [
  ^ ZnUTF8Encoder new decodeBytes: aByteArray
]

{ #category : 'startup-shutdown' }
SkGemstonePortableUtil >> unregisterAsStartupAndShutdownHandler: aClass [
  "override"


]

{ #category : 'actions' }
SkGemstonePortableUtil >> utf8BytesFromString: aString [
  ^ ZnUTF8Encoder new encodeString: aString
]
