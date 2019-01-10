start/stop
startReceivingProcess
	receivingProcess notNil ifTrue: [
		receivingProcess isTerminating ifFalse: [ receivingProcess terminate ]
	].
	receivingProcess := [self loopReceiving] newProcess.
	receivingProcess priority: self settings receivingProcessPriority.
	receivingProcess resume.