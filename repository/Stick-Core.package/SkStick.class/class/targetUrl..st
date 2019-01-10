instance creation
targetUrl: targetUrl
	| inst |
	inst := self basicNew.
	inst targetUrl: targetUrl.
	inst initialize.
	^inst