# ZeroMQ - Swift Bindings for iOS

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![License][mit-badge]][mit-url]

This project provides iOS [Swift](http://swift.org) bindings for the
[ZeroMQ](http://zeromq.org) C library. The code is written in Swift 3 and uses
a bundled stable iOS [`libzmq.a`](https://github.com/zeromq/libzmq) binary.

**Note: At the moment, please consider the project experimental.**

> ZeroMQ (also spelled ØMQ, 0MQ or ZMQ) is a high-performance asynchronous
> messaging library, aimed at use in distributed or concurrent applications. It
> provides a message queue, but unlike message-oriented middleware, a ZeroMQ
> system can run without a dedicated message broker. The library's API is
> designed to resemble that of Berkeley sockets.

## Requirements

- iOS 10+
- XCcode 8.0+

## Project Goals

- [ ] Provide an easy to use API to ZeroMQ using Swift language idioms
- [x] Provide up to date ZeroMQ binaries for iOS (Currently 4.1.5)
- [ ] Support linux and macOS plaforms for server-side projects
- [x] Support iOS platform for mobile app projects
- [ ] Support watchOS, tvOS and MacOS platforms
- [x] CocoaPods support
- [ ] Carthage support
- [ ] Swift package manager support
- [ ] More official ZeroMQ examples written
- [ ] Wrap more ZeroMQ API

## Example

```swift
import ZeroMQ

let (major, minor, patch) = ZeroMQ.version
print("ZeroMQ library version is \(major).\(minor).\(patch)")
```

More examples can be found in the
[examples](https://github.com/azawawi/swift-zmq-examples) github repository.

## Installation


### [CocoaPods](http://cocoapods.org)

*TODO*

### [Carthage](http://github.com/Carthage/Carthage)

*TODO*

### [Swift Pakcage Manager (SPM)](http://swift.org/package-manager)

*TODO*

## Testing

TODO


## Troubleshooting

TODO

## See Also

- [Zewo's ZeroMQ swift bindings](https://github.com/ZewoGraveyard/ZeroMQ)

## Author & License

Copyright (c) 2016 [Ahmad M. Zawawi](https://github.com/azawawi) under the
[MIT license](LICENSE).

A prebuilt iOS universal [`libzmq.a`](https://github.com/zeromq/libzmq) binary
is also included with this library under the
[LGPL](https://github.com/zeromq/libzmq#license) license.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
