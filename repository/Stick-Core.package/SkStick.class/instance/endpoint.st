accessing
endpoint
	^ endpoint ifNil: [ endpoint := self createEndpoint ]