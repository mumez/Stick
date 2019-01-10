accessing
reconnectMutex
	^reconnectMutex ifNil: [ reconnectMutex := Mutex new ]