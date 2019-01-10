reconnecting
beSwitchy: newTargetUrlBlock
	self
		onError: [ :ex | 
			ex isReconnectEnded
				ifTrue: [ self switch: (newTargetUrlBlock cull: self) ] ]