# SwiftyZeroMQ - ZeroMQ Swift Bindings for iOS

[![CI Status][travis-badge]][travis-url]
[![Swift][swift-badge]][swift-url]
[![ZeroMQ][zeromq-badge]][zeromq-url]
[![Platform][platform-badge]][platform-url]
[![CocoaPods][cocoapods-badge]][cocoapods-url]
[![Carthage][carthage-badge]][carthage-url]
[![License][mit-badge]][mit-url]

This framework provides iOS [Swift](http://swift.org) bindings for the
[ZeroMQ](http://zeromq.org) C library. It is written in Swift 3 and uses a
bundled stable iOS [`libzmq.a`](https://github.com/zeromq/libzmq) binary.

## ZeroMQ

> ZeroMQ (also spelled ØMQ, 0MQ or ZMQ) is a high-performance asynchronous
> messaging library, aimed at use in distributed or concurrent applications. It
> provides a message queue, but unlike message-oriented middleware, a ZeroMQ
> system can run without a dedicated message broker. The library's API is
> designed to resemble that of Berkeley sockets.

## Requirements

- iOS 8+
- Xcode 8.0+
- Swift 3.0+
- Bitcode enabled Xcode project

## Project Goals

- [x] Provide stable ZeroMQ binaries for iOS 8.0+ (v4.1.5 with Bitcode)
- [x] CocoaPods package manager support
- [x] Carthage package manager support
- [ ] Provide an easy-to-use API for ZeroMQ using Swift
- [ ] Finish user guide documentation
- [ ] Support watchOS and tvOS platforms
- [ ] Support Linux and macOS platforms for server-side projects
- [ ] More official ZeroMQ examples written
- [ ] Wrap more ZeroMQ API
- [ ] Example demo project for `pod try SwiftyZeroMQ`

## Usage

```swift
import SwiftyZeroMQ

let (major, minor, patch, versionString) = SwiftyZeroMQ.version
print("ZeroMQ library version is \(major).\(minor) with patch level .\(patch)")
print("ZeroMQ library version is \(versionString)")
```

Please consult the [user guide](UserGuide.md) for documentation and examples.
More examples can also be found in the
[examples](https://github.com/azawawi/swift-zmq-examples) github repository.

## Installation

Please check the [installation](UserGuide.md#Installation) section in the user
guide.

## Testing

- In Xcode, open the project and type ⌘U to test it.

*OR*

- In the terminal, please make sure that you have
[`xcpretty`](https://github.com/supermarin/xcpretty) and then run:
```bash
$ gem install xcpretty # Needs to be installed once for prettier output
$ ./run-tests.sh       # This will run 'xcodebuild test'
```

## See Also

- For Linux and MacOS support with SwiftPM, please see [Zewo's ZeroMQ swift bindings](https://github.com/ZewoGraveyard/ZeroMQ).

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

[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
