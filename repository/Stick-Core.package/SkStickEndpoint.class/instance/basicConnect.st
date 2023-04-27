actions
basicConnect

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