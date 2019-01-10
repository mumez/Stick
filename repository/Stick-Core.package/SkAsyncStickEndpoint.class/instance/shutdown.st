initialize-release
shutdown
	[self releaseProcesses.
	sendQueue ifNotNil: [sendQueue flush].
	sendQueue := nil] forkAt: Processor userBackgroundPriority 