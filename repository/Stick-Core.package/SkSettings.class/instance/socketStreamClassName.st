accessing
socketStreamClassName
	^self at: #socketStreamClassName ifAbsentPut: [SkPortableUtil default defaultSocketStreamClassName]