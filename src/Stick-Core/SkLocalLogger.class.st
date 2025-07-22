Class {
	#name : 'SkLocalLogger',
	#superclass : 'Object',
	#instVars : [
		'logLevel'
	],
	#classInstVars : [
		'defaultLogLevel'
	],
	#category : 'Stick-Core',
	#package : 'Stick-Core'
}

{ #category : 'accessing' }
SkLocalLogger class >> defaultLogLevel [
	^defaultLogLevel ifNil: [ defaultLogLevel := 2]
]

{ #category : 'accessing' }
SkLocalLogger class >> defaultLogLevel: anInteger [
	^defaultLogLevel := anInteger
]

{ #category : 'class initialization' }
SkLocalLogger class >> initialize [
	defaultLogLevel := nil
]

{ #category : 'actions' }
SkLocalLogger >> debug: record [
	"Use Nagare-logger for production"
	self shouldLogDebug ifFalse: [ ^self ].
	self log: record tag: 'DEBUG'
]

{ #category : 'actions' }
SkLocalLogger >> error: record [
	"Use Nagare-logger for production"
	self shouldLogError ifFalse: [ ^self ].
	self log: record tag: 'ERROR'
]

{ #category : 'actions' }
SkLocalLogger >> info: record [
	"Use Nagare-logger for production"
	self shouldLogInfo ifFalse: [ ^self ].
	self log: record tag: 'INFO'
]

{ #category : 'initialize-release' }
SkLocalLogger >> initialize [
	logLevel := nil
]

{ #category : 'acccessing' }
SkLocalLogger >> isDebugging [
	^self logLevel > 0
]

{ #category : 'acccessing' }
SkLocalLogger >> isDebugging: aBoolean [
	| level |
	level := aBoolean ifTrue: [self defaultLogLevel] ifFalse: [0].
	self logLevel: level
]

{ #category : 'private' }
SkLocalLogger >> log: record tag: tagString [
	Transcript cr; show: tagString, ':', record asString
]

{ #category : 'acccessing' }
SkLocalLogger >> logLevel [
	^logLevel ifNil: [logLevel := self class defaultLogLevel ]
]

{ #category : 'acccessing' }
SkLocalLogger >> logLevel: anInteger [
	logLevel := anInteger
]

{ #category : 'testing' }
SkLocalLogger >> shouldLogDebug [
	^self logLevel >= 3
]

{ #category : 'testing' }
SkLocalLogger >> shouldLogError [
	^self logLevel >= 1
]

{ #category : 'testing' }
SkLocalLogger >> shouldLogInfo [
	^self logLevel >= 4
]

{ #category : 'testing' }
SkLocalLogger >> shouldLogWarn [
	^self logLevel >= 2
]

{ #category : 'actions' }
SkLocalLogger >> warn: record [
	"Use Nagare-logger for production"
	self shouldLogWarn ifFalse: [ ^self ].
	self log: record tag: 'WARN'
]
