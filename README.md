# SwiftyZeroMQ - ZeroMQ Swift Bindings for iOS

[![CI Status][travis-badge]][travis-url]
[![Swift][swift-badge]][swift-url]
[![ZeroMQ][zeromq-badge]][zeromq-url]
[![Platform][platform-badge]][platform-url]
[![Carthage][carthage-badge]][carthage-url]
[![CocoaPods][cocoapods-badge]][cocoapods-url]
[![CocoaDocs][cocoadocs-badge]][cocoadocs-url]
[![License][mit-badge]][mit-url]

This library provides easy-to-use iOS [Swift](http://swift.org) bindings for
the [ZeroMQ](http://zeromq.org) C++ library. It is written in Swift 3 and
features a bundled stable iOS
[`libzmq`](https://github.com/zeromq/libzmq) library. It provides ZeroMQ's
low-level API along with an object-oriented API.

## What is ZeroMQ?

> ZeroMQ (also spelled ØMQ, 0MQ or ZMQ) is a high-performance asynchronous
> messaging library, aimed at use in distributed or concurrent applications. It
> provides a message queue, but unlike message-oriented middleware, a ZeroMQ
> system can run without a dedicated message broker. The library's API is
> designed to resemble that of Berkeley sockets.

## Requirements

- iOS 9+
- Xcode 8.0+ and Swift 3.0
- Bitcode-enabled Xcode project

## Usage

### Version

```swift
import SwiftyZeroMQ

// Print ZeroMQ library and our framework version
let (major, minor, patch, versionString) = SwiftyZeroMQ.version
print("ZeroMQ library version is \(major).\(minor) with patch level .\(patch)")
print("ZeroMQ library version is \(versionString)")
print("SwiftyZeroMQ version is \(SwiftyZeroMQ.frameworkVersion)")
```

### Request-reply Pattern

```swift
import SwiftyZeroMQ

do {
    // Define a TCP endpoint along with the text that we are going to send/recv
    let endpoint     = "tcp://127.0.0.1:5555"
    let textToBeSent = "Hello world from iOS"

    // Request socket
    let context      = try SwiftyZeroMQ.Context()
    let requestor    = try context.socket(.request)
    try requestor.connect(endpoint)

    // Reply socket
    let replier      = try context.socket(.reply)
    try replier.bind(endpoint)

    // Send it without waiting and check the reply on other socket
    try requestor.send(string: textToBeSent, options: .dontWait)
    let reply = try replier.recv()
    if reply == textToBeSent {
        print("Match")
    } else {
        print("Mismatch")
    }

} catch {
    print(error)
}
```

Please consult the [documentation manual](Documentation/Manual.md) for more
information. Older examples can also be found in the
[examples](https://github.com/azawawi/swift-zmq-examples) github repository.

## Planned Features

- [x] An easy-to-use object-oriented API for ZeroMQ using Swift
- [x] Low-level ZeroMQ API
- [x] Provide stable ZeroMQ binaries for iOS 9+ (v4.1.5 with Bitcode)
- [x] CocoaPods and Carthage package manager support
- [x] Documentation Manual
- [x] Example iOS project for `pod try SwiftyZeroMQ`
- [ ] Support watchOS and tvOS platforms
- [ ] Support Linux and macOS platforms for server-side projects
- [ ] More official ZeroMQ examples written
- [ ] More ZeroMQ API wrapped

## See Also

- For Linux and macOS support with SwiftPM, please see [Zewo's ZeroMQ swift bindings](https://github.com/ZewoGraveyard/ZeroMQ).

## Author & License

Copyright (c) 2016 [Ahmad M. Zawawi](https://github.com/azawawi) under the
[MIT license](LICENSE).

A prebuilt iOS universal [`libzmq.a`](https://github.com/zeromq/libzmq) binary
is also included with this library under the
[LGPL](https://github.com/zeromq/libzmq#license) license.

[travis-badge]: https://travis-ci.org/azawawi/SwiftyZeroMQ.svg?branch=master
[travis-url]: https://travis-ci.org/azawawi/SwiftyZeroMQ

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org

[zeromq-badge]: https://img.shields.io/badge/ZeroMQ-4.1.5-blue.svg?style=flat
[zeromq-url]: https://zeromq.org

[platform-badge]: https://img.shields.io/badge/Platforms-iOS-yellow.svg?style=flat
[platform-url]: https://swift.org

[carthage-badge]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[carthage-url]: https://github.com/Carthage/Carthage

[cocoapods-badge]: https://img.shields.io/cocoapods/v/SwiftyZeroMQ.svg
[cocoapods-url]: https://cocoapods.org/?q=swiftyzeromq

[cocoadocs-badge]: https://img.shields.io/badge/docs-%E2%9C%93-blue.svg
[cocoadocs-url]: http://cocoadocs.org/docsets/SwiftyZeroMQ

[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
