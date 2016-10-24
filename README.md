# SwiftyZeroMQ - ZeroMQ Swift Bindings for iOS

[![CI Status][travis-badge]][travis-url]
[![Swift][swift-badge]][swift-url]
[![ZeroMQ][zeromq-badge]][zeromq-url]
[![Platform][platform-badge]][platform-url]
[![CocoaPods][cocoapods-badge]][cocoapods-url]
[![Carthage][carthage-badge]][carthage-url]
[![License][mit-badge]][mit-url]

This project provides iOS [Swift](http://swift.org) bindings for the
[ZeroMQ](http://zeromq.org) C library. The code is written in Swift 3 and uses
a bundled stable iOS [`libzmq.a`](https://github.com/zeromq/libzmq) binary.

> ZeroMQ (also spelled ØMQ, 0MQ or ZMQ) is a high-performance asynchronous
> messaging library, aimed at use in distributed or concurrent applications. It
> provides a message queue, but unlike message-oriented middleware, a ZeroMQ
> system can run without a dedicated message broker. The library's API is
> designed to resemble that of Berkeley sockets.

## Requirements

- iOS 8+
- Xcode 8.0+
- Bitcode enabled

## Project Goals

- [ ] Provide an easy-to-use API for ZeroMQ using Swift
- [x] Provide up to date ZeroMQ binaries for iOS (4.1.5 with Bitcode enabled)
- [x] Provide iOS 8.0+ binaries
- [x] Support iOS platform
- [ ] Support watchOS and tvOS platforms
- [ ] Support Linux and macOS platforms for server-side projects
- [x] CocoaPods support
- [x] Carthage support
- [ ] Swift package manager support
- [ ] More official ZeroMQ examples written
- [ ] Wrap more ZeroMQ API
- [x] Bitcode enabled

## Example

```swift
import SwiftyZeroMQ

let (major, minor, patch) = SwiftyZeroMQ.version
print("ZeroMQ library version is \(major).\(minor).\(patch)")
```

More examples can be found in the
[examples](https://github.com/azawawi/swift-zmq-examples) github repository.

## Bundled ZeroMQ library

The bundled `libzmq.a` is a static universal binary that is compiled from pristine
ZeroMQ `4.1.5` sources with `8.0` as the minimum iOS version with [Bitcode](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html) enabled. The library contains the following architectures:
- armv7  (iPhone 3GS till iPhone 4S)
- armv7s (iPhone 5 till iPhone 5c)
- arm64  (iPhone 5s and later)
- i386 and x86_64  (Simulator)

## Installation

### [CocoaPods](http://cocoapods.org)

- Add the following lines to your `Podfile`:
```ruby
use_frameworks!
pod 'SwiftyZeroMQ', '~> 1.0.14'
```

- Run the following command in the project root directory:
```bash
$ pod install
```

- Open the project in Xcode with the following command:
```bash
$ open YourProject.xcworkspace
```

### [Carthage](http://github.com/Carthage/Carthage)

In the project root directory:

- Add the following lines to your 'Cartfile':
```
github "azawawi/SwiftyZeroMQ" ~> 1.0.14
```

- Build the `SwiftyZeroMQ.framework` with the following commands:
```
$ carthage bootstrap --platform iOS
```

- Open your Xcode project (if not open already)

- In your target's settings, please click on the "+" button under the "Embedded
Binaries" section and add `Carthage/Build/iOS/SwiftyZeroMQ.framework`

### [Swift Pakcage Manager (SPM)](http://swift.org/package-manager)

*TODO*. PRs are welcome

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
