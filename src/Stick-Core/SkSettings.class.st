Class {
	#name : 'SkSettings',
	#superclass : 'Object',
	#instVars : [
		'settingsDict'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'instance creation' }
SkSettings class >> default [
	^default ifNil: [ default := self new ]
]

{ #category : 'class initialization' }
SkSettings class >> initialize [
	super initialize.
	default := nil
]

{ #category : 'actions-dictionary' }
SkSettings >> at: key [
	^self settingsDict at: key
]

{ #category : 'actions-dictionary' }
SkSettings >> at: key ifAbsent: aBlock [
	^self settingsDict at: key ifAbsent: aBlock
]

{ #category : 'actions-dictionary' }
SkSettings >> at: key ifAbsentPut: aBlock [
	^self settingsDict at: key ifAbsentPut: aBlock
]

{ #category : 'actions-dictionary' }
SkSettings >> at: key put: value [
	^self settingsDict at: key put: value
]

{ #category : 'accessing' }
SkSettings >> connectionTimeoutSeconds [
	^self at: #connectionTimeoutSeconds ifAbsentPut: [20]
]

{ #category : 'accessing' }
SkSettings >> connectionTimeoutSeconds: seconds [
	self at: #connectionTimeoutSeconds put: seconds
]

{ #category : 'initialize-release' }
SkSettings >> initialize [
	settingsDict := nil
]

{ #category : 'accessing' }
SkSettings >> maxReconnects [
	^self at: #maxReconnects ifAbsentPut: [3]
]

{ #category : 'accessing' }
SkSettings >> maxReconnects: times [
	self at: #maxReconnects put: times
]

{ #category : 'accessing' }
SkSettings >> nameResolveTimeoutSeconds [
	^self at: #nameResolveTimeoutSeconds ifAbsentPut: [20]
]

{ #category : 'accessing' }
SkSettings >> nameResolveTimeoutSeconds: seconds [
	self at: #nameResolveTimeoutSeconds put: seconds
]

{ #category : 'accessing' }
SkSettings >> receivingProcessPriority [
	^self at: #receivingProcessPriority ifAbsentPut: [Processor userInterruptPriority]
]

{ #category : 'accessing' }
SkSettings >> receivingProcessPriority: priority [
	self at: #receivingProcessPriority put: priority
]

{ #category : 'accessing' }
SkSettings >> reconnectIncrementRatio [
	^self at: #reconnectIncrementRatio ifAbsentPut: [1.0]
]

{ #category : 'accessing' }
SkSettings >> reconnectIncrementRatio: aFloat [
	self at: #reconnectIncrementRatio put: aFloat
]

{ #category : 'accessing' }
SkSettings >> reconnectIntervalSeconds [
	^self at: #reconnectIntervalSeconds ifAbsentPut: [3]
]

{ #category : 'accessing' }
SkSettings >> reconnectIntervalSeconds: seconds [
	self at: #reconnectIntervalSeconds put: seconds
]

{ #category : 'accessing' }
SkSettings >> sendingProcessPriority [
	^self at: #sendingProcessPriority ifAbsentPut: [Processor userSchedulingPriority - 5]
]

{ #category : 'accessing' }
SkSettings >> sendingProcessPriority: priority [
	self at: #sendingProcessPriority put: priority
]

{ #category : 'accessing-private' }
SkSettings >> settingsDict [
	^ settingsDict ifNil: [settingsDict := IdentityDictionary new]
]

{ #category : 'accessing-private' }
SkSettings >> settingsDict: anObject [
	settingsDict := anObject
]

{ #category : 'accessing' }
SkSettings >> socketStreamClassName [
	^self at: #socketStreamClassName ifAbsentPut: [SkPortableUtil default defaultSocketStreamClassName]
]

{ #category : 'accessing' }
SkSettings >> switchingTargetUrls [
	^self at: #switchingTargetUrls ifAbsentPut: [#()]
]

{ #category : 'accessing' }
SkSettings >> switchingTargetUrls: anArray [
	self at: #switchingTargetUrls put: anArray
]
