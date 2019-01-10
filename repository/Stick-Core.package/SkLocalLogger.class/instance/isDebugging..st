acccessing
isDebugging: aBoolean
	| level |
	level := aBoolean ifTrue: [self defaultLogLevel] ifFalse: [0].
	self logLevel: level