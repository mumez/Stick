initialize-release
releaseProcesses
	shouldLoopSending := false.
	sendingProcess ifNotNil: [sendingProcess terminate.  sendingProcess := nil ].
	receivingProcess ifNotNil: [receivingProcess terminate.  receivingProcess := nil ].
	