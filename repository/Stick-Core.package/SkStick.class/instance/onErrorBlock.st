accessing
onErrorBlock
	^ onErrorBlock ifNil: [ onErrorBlock := self defaultErrorHandingBlock]