factory
endpointClassForScheme: schemeName
	schemeName ifNil: [ ^nil ].
	(schemeName beginsWith:  'sync') ifTrue: [ ^SkSyncStickEndpoint ].
	^SkAsyncStickEndpoint 