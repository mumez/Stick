actions
socketStreamToHost: hostIP port: portNumber settings: settings
	Smalltalk globals at: settings socketStreamClassName ifPresent: [ :cls |
		^ cls openConnectionToHost: hostIP port: portNumber timeout: settings connectionTimeoutSeconds
	 ].
	^nil