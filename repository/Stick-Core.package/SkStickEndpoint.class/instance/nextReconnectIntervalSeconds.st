private
nextReconnectIntervalSeconds
	^ reconnectIntervalSeconds := reconnectIntervalSeconds * self settings reconnectIncrementRatio 