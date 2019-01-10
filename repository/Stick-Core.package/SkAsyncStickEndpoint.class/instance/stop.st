start/stop
stop
	self sendQueue nextPut: #[].
	shouldLoopSending := false.