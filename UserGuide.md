# User Guide

This is the user guide for **SwiftyZeroMQ**. You will find useful documentation
and examples in the sections below.

## Installation

### Manual project inclusion

* Download framework source code from [here](https://github.com/azawawi/SwiftyZeroMQ/releases/)
* Drag the project into your project.
* In your target's settings, please click on the **+** button under the **Embedded
Binaries** section and add `SwiftyZeroMQ.framework`
* Add `import SwiftyZeroMQ` in your code to test it.
* Happy hacking :)

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

- In your target's settings, please click on the **+** button under the
**Embedded Binaries** section and add
`Carthage/Build/iOS/SwiftyZeroMQ.framework`

### [Swift Pakcage Manager (SPM)](http://swift.org/package-manager)

At the time of this writing (October 2016), Apple's SPM or SwiftPM does not iOS.
Pull requests are more than welcome once the iOS support lands in a future
version.

## Bundled ZeroMQ library

The bundled `libzmq.a` is a static universal binary that is compiled from pristine
ZeroMQ `4.1.5` sources with `8.0` as the minimum iOS version with [Bitcode](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html) enabled. The library contains the following architectures:
- armv7  (iPhone 3GS till iPhone 4S)
- armv7s (iPhone 5 till iPhone 5c)
- arm64  (iPhone 5s and later)
- i386 and x86_64  (Simulator)

## Import

To import this module, please type:

```swift
import SwiftyZeroMQ
```

## Low-level API

Low-level API is available once you import this module, ZeroMQ C++ API is
usually prefixed by `zmq_`. For example, to print library version, please
type:

```swift
var major: Int32 = 0
var minor: Int32 = 0
var patch: Int32 = 0
zmq_version(&major, &minor, &patch)
print("ZeroMQ library version is \(major).\(minor).\(patch)")
```

For more information about the ZeroMQ low level API, please consult
[ZeroMQ 4.1 API](http://api.zeromq.org/4-1:_start).

## High level API

High-level API is available once you import this module under the `SwiftyZeroMQ`
virtual namespace (i.e. struct). The following section describe the high-level
API.

### Error Handling

All the methods currently throw a `ZeroMQError` which implements `Error` and
`CustomStringConvertible`. To handle it, please use:

```swift
do {
    let _ = try SwiftyZeroMQ.Context()
} catch {
    print("Context creation failure: \(error)")
}
```

### Framework & Library Version

- To get the ZeroMQ library version as a tuple, please use
`SwiftyZeroMQ.version`:

```swift
// Library version as a tuple
let (major, minor, patch, versionString) = SwiftyZeroMQ.version
print("ZeroMQ library version is \(major).\(minor) with patch level .\(patch)")
print("ZeroMQ library version is \(versionString)")
```

- To get the ZeroMQ framework version a string, please use
`SwiftyZeroMQ.frameworkVersion`:

```swift
// Framework version as a string
print("SwiftyZeroMQ framework version is \(SwiftyZeroMQ.frameworkVersion)")
```

### Capability/Feature Support

Use `SwiftyZero.has` to check whether the ZeroMQ capability (or feature) is
enabled or not. The list of capabilities (or features) that can be checked:
- `.ipc`    - the library supports the `ipc://` protocol
- `.pgm`    - the library supports the `pgm://` protocol
- `.tipc`   - the library supports the `tipc://` protocol
- `.norm`   - the library supports the `norm://` protocol
- `.curve`  - the library supports the [`CURVE`](http://curvezmq.org) security
  mechanism
- `.gssapi` - the library supports the GSSAPI security mechanism

The following examples show typical usage:

```swift
if SwiftyZeroMQ.has(.ipc) {
  print("The library supports the ipc:// protocol")
}

if SwiftyZeroMQ.has(.curve) {
  print("The library supports the CURVE security mechanism")
}
```
