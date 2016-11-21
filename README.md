# SwiftyZeroMQ - ZeroMQ Swift Bindings for iOS, macOS, tvOS and watchOS

[![CI Status][travis-badge]][travis-url]
[![Swift][swift-badge]][swift-url]
[![ZeroMQ][zeromq-badge]][zeromq-url]
[![Platform][platform-badge]][platform-url]
[![Carthage][carthage-badge]][carthage-url]
[![CocoaPods][cocoapods-badge]][cocoapods-url]
[![License][mit-badge]][mit-url]

This library provides easy-to-use iOS, macOS, tvOS and watchOS
[Swift](http://swift.org) bindings for the [ZeroMQ](http://zeromq.org) C++
library. It is written in Swift 3 and features a bundled stable
[`libzmq`](https://github.com/zeromq/libzmq) library. It provides ZeroMQ's
low-level API along with an object-oriented API.

## What is ZeroMQ?

> ZeroMQ (also spelled ØMQ, 0MQ or ZMQ) is a high-performance asynchronous
> messaging library, aimed at use in distributed or concurrent applications. It
> provides a message queue, but unlike message-oriented middleware, a ZeroMQ
> system can run without a dedicated message broker. The library's API is
> designed to resemble that of Berkeley sockets.

## Requirements

- iOS 9+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.1 and Swift 3.0
- Bitcode-enabled Xcode project for non-MacOS

## Usage

Please consult the [**Documentation Manual**](Documentation/Manual.md) for more
information. Older examples can also be found in the
[examples](https://github.com/azawawi/swift-zmq-examples) github repository.

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
    let textToBeSent = "Hello world"

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

### Poller

```swift
import SwiftyZeroMQ

do {
    // Define a TCP endpoint along with the text that we are going to send/recv
    let endpoint     = "tcp://127.0.0.1:5555"

    // Request socket
    let context      = try SwiftyZeroMQ.Context()
    let requestor    = try context.socket(.request)
    try requestor.connect(endpoint)

    // Reply socket
    let replier      = try context.socket(.reply)
    try replier.bind(endpoint)

    // Create a Poller and add both requestor and replier
    let poller       = SwiftyZeroMQ.Poller()
    try poller.register(socket: requestor, flags: [.pollIn, .pollOut])
    try poller.register(socket: replier, flags: [.pollIn, .pollOut])

    try requestor.send(string: "Hello replier!")

    // wait to let request come through
    sleep(1)

    var updates = try poller.poll()
    if updates[replier] == SwiftyZeroMQ.PollFlags.pollIn {
        print("Replier has data to be received.")
    }
    else {
        print("Expected replier to be in pollIn state.")
        return
    }

    try _ = replier.recv()

    updates = try poller.poll()
    if updates[replier] == SwiftyZeroMQ.PollFlags.none {
        print("All data has been received")
    }
    else {
        print("Expected replier to be in none state.")
        return
    }
} catch {
    print(error)
}
```

## Planned Features

- [x] An easy-to-use object-oriented API for ZeroMQ using Swift
- [x] Low-level ZeroMQ API
- [x] Provide stable ZeroMQ binaries for iOS 9+ (v4.2.0 with Bitcode)
- [x] CocoaPods and Carthage package manager support
- [x] Documentation Manual
- [x] Example iOS, macOS, tvOS and watchOS project for `pod try SwiftyZeroMQ`
- [x] Support iOS, macOS, tvOS and watchOS platforms
- [ ] More official ZeroMQ examples written
- [ ] More ZeroMQ API wrapped

## See Also

- For Linux and macOS support with SwiftPM, please see [Zewo's ZeroMQ Swift bindings](https://github.com/ZewoGraveyard/ZeroMQ).

## Author & License

Copyright (c) 2016 [Ahmad M. Zawawi](https://github.com/azawawi) under the
[MIT license](LICENSE).

A prebuilt iOS, macOS, tvOS and watchOS universal
[`libzmq`](https://github.com/zeromq/libzmq) library is bundled with this
library under the [LGPL](https://github.com/zeromq/libzmq#license) license.

[travis-badge]: https://travis-ci.org/azawawi/SwiftyZeroMQ.svg?branch=master
[travis-url]: https://travis-ci.org/azawawi/SwiftyZeroMQ

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org

[zeromq-badge]: https://img.shields.io/badge/ZeroMQ-4.2.0-blue.svg?style=flat
[zeromq-url]: https://zeromq.org

[platform-badge]: https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-blue.svg?style=flat
[platform-url]: http://cocoadocs.org/docsets/SwiftyZeroMQ

[carthage-badge]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[carthage-url]: https://github.com/Carthage/Carthage

[cocoapods-badge]: https://img.shields.io/cocoapods/v/SwiftyZeroMQ.svg
[cocoapods-url]: https://cocoapods.org/?q=swiftyzeromq

[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
