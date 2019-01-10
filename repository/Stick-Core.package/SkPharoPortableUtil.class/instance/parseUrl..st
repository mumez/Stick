actions
parseUrl: targetUrl
	| dict url |
	dict := super parseUrl: targetUrl.
	url := targetUrl asUrl.
	dict at: #scheme put: url scheme.
	dict at: #host put: url host.
	dict at: #port put: url port.
	url username ifNotNil: [:n | dict at: #username put: n  ].
	url password ifNotNil: [:p | dict at: #password put: p  ]. 
	^dict
	
	