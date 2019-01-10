accessing
settings
	^ settings ifNil: [settings := SkSettings default ]