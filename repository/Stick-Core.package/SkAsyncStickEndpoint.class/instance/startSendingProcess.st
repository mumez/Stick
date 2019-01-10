start/stop
startSendingProcess
	sendingProcess notNil ifTrue: [
		sendingProcess isTerminating ifFalse: [ sendingProcess terminate ]
	].
	shouldLoopSending := true.
	sendingProcess := [self loopSending] newProcess.
	sendingProcess priority: self settings sendingProcessPriority.
	sendingProcess resume.