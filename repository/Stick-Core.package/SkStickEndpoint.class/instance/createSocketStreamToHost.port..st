factory
createSocketStreamToHost: ipAddr port: portNum
	^self portableUtil socketStreamToHost: ipAddr port: portNum settings: self settings