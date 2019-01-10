actions
error: record
	"Use Nagare-logger for production"
	self shouldLogError ifFalse: [ ^self ].
	self log: record tag: 'ERROR'