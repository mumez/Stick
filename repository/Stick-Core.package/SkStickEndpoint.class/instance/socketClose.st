private
socketClose
	socketStream ifNil: [^self].
	[socketStream close] on: NetworkError do: [:ex | self logger error: ex].
	self logger info: 'Sticking socket closed: ', socketStream printString.
	socketStream := nil