reconnecting
beSwitchyWithAll: switchingUrls
	switchingUrls ifEmpty: [ ^self releaseThenConnect].
	self beSwitchy: [ :ignore | | index |
		index := (switchingUrls indexOf: self targetUrl).
		switchingUrls atWrap: index + 1.
	]
	