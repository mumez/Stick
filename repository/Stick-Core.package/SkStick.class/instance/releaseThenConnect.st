reconnecting
releaseThenConnect
	self release.
	self endpoint waitFor: self releaseThenConnectIntervalSeconds.
	self connect