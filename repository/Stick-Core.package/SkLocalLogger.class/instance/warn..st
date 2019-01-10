actions
warn: record
	"Use Nagare-logger for production"
	self shouldLogWarn ifFalse: [ ^self ].
	self log: record tag: 'WARN'