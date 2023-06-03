accessing
reconnectMutex
	^reconnectMutex ifNil: [ reconnectMutex := self createMutex ]