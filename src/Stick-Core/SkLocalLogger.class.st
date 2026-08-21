"
I am a simple Transcript-based logger used as Stick's default logger. I support leveled logging (error/warn/info/debug) and am intended for local development; production deployments are expected to substitute a different logger (see method comments referencing Nagare-logger).

Responsibility:
- I filter log calls against a numeric #logLevel (0=off .. 4=debug) and write accepted entries to the Transcript with a severity tag.
- I fall back to a class-side #defaultLogLevel when no instance-level level has been set.

Collaborators:
- SkStick / SkStickEndpoint: call #error:, #warn:, #info:, #debug: to report connection lifecycle events and failures.

Public API and Key Messages:
- #error: / #warn: / #info: / #debug: - log a record at the given severity if #logLevel permits.
- #logLevel / #logLevel: - get/set the numeric threshold (1=error, 2=warn, 3=debug, 4=info; 0 disables logging).
- #isDebugging / #isDebugging: - convenience toggle between defaultLogLevel and 0.

Implementation Points:
- Severity thresholds are cumulative (e.g. shouldLogInfo requires level >= 4), so raising the level enables all lower-severity categories too.
"
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
