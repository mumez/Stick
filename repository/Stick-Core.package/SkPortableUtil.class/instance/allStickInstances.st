accessing
allStickInstances
	^SkStick allSubInstances reject: [ :each |each isReleased ]