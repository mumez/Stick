accessing
onReceiveBlock
	^ onReceiveBlock ifNil: [ onReceiveBlock := self defaultOnReceiveBlock ]