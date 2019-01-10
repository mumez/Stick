initialize-release
release
	self isReleased ifTrue: [^self].
	status := SkStickStatus released.
	endpoint ifNotNil: [endpoint onReleased].
	endpoint := nil