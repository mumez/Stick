# Stick
An event-based socket reconnection layer for [Pharo](https://pharo.org) smalltalk

## Features

- [Socket.IO](https://socket.io/) like event-based API
- Supports auto reconnection to a server
- Supports auto switching to alternative servers
- Provides base classes for implementing sync/async socket client 

## Installation

```smalltalk

Metacello new
  baseline: 'Stick';
  repository: 'github://mumez/Stick/src';
  load.
```

## Sample Code

```smalltalk

stick := SkStick targetUrl: 'async://google.com:80'.
stick logger logLevel: 5.
stick onConnected: [ stick logger info: 'connected' ].
stick onError: [:ex | ex isReconnectEnded ifTrue: [stick stick]].
stick onReceive: [ :stream | | size data |
    data := stream next: 10.
    Transcript cr; show: data asString.
].
stick connect.

stick send: #[0 1 2 3 4 5 6 7 8 9].
```

