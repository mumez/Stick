factory
createEndpoint
	| dict endpointClass ep |
	dict := 	self portableUtil parseUrl: self targetUrl.
	endpointClass := self endpointClassForScheme: (dict at: #scheme ifAbsent: [ ]).
	endpointClass ifNil: [ self portableUtil signalException: (SkUnsupportedUrlScheme new) ].
	ep := endpointClass on: self.
	ep remoteHost: (dict at: #host ifAbsent: [ ]).
	ep remotePortNumber: (dict at: #port ifAbsent: [ ]).
	^ep