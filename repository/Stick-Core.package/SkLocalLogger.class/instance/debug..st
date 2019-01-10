actions
debug: record
	"Use Nagare-logger for production"
	self shouldLogDebug ifFalse: [ ^self ].
	self log: record tag: 'DEBUG'