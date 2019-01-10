actions
info: record
	"Use Nagare-logger for production"
	self shouldLogInfo ifFalse: [ ^self ].
	self log: record tag: 'INFO'