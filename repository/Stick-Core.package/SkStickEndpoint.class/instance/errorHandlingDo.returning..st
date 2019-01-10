private
errorHandlingDo: aBlock returning: returnBlock
	^[aBlock value] on: Error do: [ :ex | self onErrorSignaled: ex. returnBlock value]