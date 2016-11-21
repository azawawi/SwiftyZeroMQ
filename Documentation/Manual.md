# Documentation Manual

This is the documentation manual for **SwiftyZeroMQ**. You will find useful
documentation and examples in the sections below.

- [Documentation Manual](#documentation-manual)
  - [Installation](#installation)
    - [Manual project inclusion](#manual-project-inclusion)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
  - [Testing](#testing)
  - [Bundled ZeroMQ library](#bundled-zeromq-library)
  - [Import](#import)
  - [Low-level API](#low-level-api)
  - [High level API](#high-level-api)
    - [Error Handling](#error-handling)
    - [Framework & Library Version](#framework-library-version)
    - [Capability Support](#capabilityfeature-support)
    - [Context](#context)
    - [Socket](#socket)
    - [Poller](#poller)

## Installation

### Manual project inclusion

* Download framework source code from [here](https://github.com/azawawi/SwiftyZeroMQ/releases/)
* Drag the project into your project.
* In your target's settings, please click on the **+** button under the
**Embedded Binaries** section and add `SwiftyZeroMQ.framework`. In case it does
not show up in the list, please close and reopen the project in Xcode.
* Add `import SwiftyZeroMQ` in your code to test it.
* Happy hacking :)

### CocoaPods

[CocoaPods](http://cocoapods.org) is a package manager that manages dependencies
for your Xcode projects.

#### Example

If you would like to try out the example iOS project, simply type:
```bash
$ pod try SwiftyZeroMQ
```

#### Steps

Please follow these steps to add SwiftyZeroMQ to your project:

- Add the following lines to your `Podfile`:
```ruby
use_frameworks!
pod 'SwiftyZeroMQ', '~> 1.0'
```

- Run the following command in the project root directory:
```bash
$ pod install
```

- Open the project in Xcode with the following command:
```bash
$ open YourProject.xcworkspace
```

### Carthage

[Carthage](http://github.com/Carthage/Carthage) is a simple, decentralized
dependency manager for Cocoa. Please follow these steps:

- Add the following lines to your 'Cartfile':
```
github "azawawi/SwiftyZeroMQ" ~> 1.0
```

- Build the `SwiftyZeroMQ.framework` with the following commands:
```
$ carthage bootstrap --platform iOS  # Build only the iOS platform
$ carthage bootstrap                 # Build all supported platforms (can be slow)
```

- Open your Xcode project (if not open already)

- In your target's settings, please click on the **+** button under the
**Embedded Binaries** section and add
`Carthage/Build/iOS/SwiftyZeroMQ.framework`

### Swift Package Manager

[Apple's Swift Package Manager](http://swift.org/package-manager) (also known as
SPM or SwiftPM) is a tool for managing the distribution of Swift code. It is
integrated with the Swift build system to automate the process of downloading,
compiling, and linking dependencies.

*At the time of this writing (October 2016), iOS is not supported.
Pull requests are more than welcome once the iOS support lands in a future
version.*

## Testing

- In Xcode, open the project and type ⌘U to test it.

*OR*

- In the terminal, please make sure that you have
[`xcpretty`](https://github.com/supermarin/xcpretty) and then run:
```bash
$ gem install xcpretty # Needs to be installed once for prettier output
$ ./run-tests.rb       # Runs framework unit tests on selected iOS versions
```

## Bundled ZeroMQ library

The bundled universal static library for ZeroMQ `4.2.0` is provided in the
`Libraries` folder. Please check the table shown below for included
architectures and minimum platform version.
[Bitcode](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html)
is enabled for all platforms except macOS.

Library|Minimum OS version|CPU Architectures
---|---|---
`libzmq-ios.a`|9.0|`armv7` (iPhone 3GS till iPhone 4S), `armv7s` (iPhone 5 till iPhone 5c), `arm64` (iPhone 5s and later), `i386` and `x86_64` (simulator)
`libzmq-macos.a`|10.11|`x86_64`
`libzmq-tvos.a`|9.0|`arm64` (Apple TV 4), `x86_64` (simulator)
`libzmq-watchos.a`|2.0|`armv7k` (Apple Watch), i386 (simulator)

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

For more information about the ZeroMQ low level API, please consult the
[ZeroMQ 4.2 API](http://api.zeromq.org/4-2:_start).

## High level API

High-level API is available once you import this module under the `SwiftyZeroMQ`
virtual namespace (i.e. struct). The following sections describe the high-level
API.

### API documentation

You can also access the
[CocoaDocs API docs](http://cocoadocs.org/docsets/SwiftyZeroMQ/) through your
browser or use Xcode Quick help.

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

### Capability Support

Use `SwiftyZero.has` to check whether the ZeroMQ capability is enabled or not.
The list of capabilities that can be checked:
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

### Context

The class `SwiftyZeroMQ.Context` is a wrapper for `zmq_context` and
predominantly handles application-level configuration and creation of
`SwiftyZeroMQ.Socket` instances:

```swift 
let context   = SwiftyZeroMQ.Context()
let requestor = context.socket(.request)
let replier   = context.socket(.reply)
```

The `.socket` method expects an argument describing the socket type required,
the full list of which is given in `SwiftyZeroMQ.SocketType`. For full details
of the available socket types see the [ZMQ
Documentation](http://zguide.zeromq.org/page%3Aall#Messaging-Patterns).

### Socket

`SwiftyZeroMQ.Socket` is the implementation of `zmq_socket` and handles sending
and receiving of messages through the `.send` and `.recv` methods, as well as
connecting to endpoints via the `.connect` and `.bind` methods, which allows
sockets to communicate with each other.

Creation of sockets is via the context, as seen in the [Context](#context)
section. In order to be able to communicate sockets must connect to an endpoint:

```swift
let endpoint = "tcp://127.0.0.1:5555"
requestor.bind(endpoint)
replier.connect(endpoint)
```

The subtleties of `.bind` vs. `.connect` are best explained by the [ZMQ Documentation](http://zeromq.org/area:faq#toc1).

Once connected to an endpoint, it is then possible to send and receive messages:

```swift
requestor.send("Hello SwiftyZeroMQ!")
let message = replier.recv() // message reads "Hello SwiftyZeroMQ!"
```

The `.recv` method will block the thread until a response is received, and so is
often used in combination with the [Poller](#poller) to check whether messages
are available.

### Poller

Using the class `SwiftyZeroMQ.Poller` it is possible to poll
`SwiftyZeroMQ.Socket` instances for status changes, such as when a `socket` has
data to be obtained by `socket.recv()`.

To monitor a socket, sockets must first be registered:

```swift
let poller = SwiftyZeroMQ.Poller()
try poller.register(socket: requestor, flags: .pollIn)
```

The `flags` argument gives those events which are to be monitored. Multiple
events can be monitored with:
```swift
try poller.register(socket: requestor, flags: [.pollIn, .pollOut])
```

When ```poller.poll()``` is invoked, it returns a dictionary `[Socket:
PollFlags]` which describes which of the monitored events have occurred. Keys
are the registered sockets, while values are which of the monitored events has
occurred (or `PollFlags.none` if none of these).

A complete list of these events is given in `SwiftyZeroMQ.PollFlags`; these
consist of:

- `PollFlags.pollIn`   - data can be obtained by `recv`.
- `PollFlags.pollOut`  - data can be sent using `send`.
- `PollFlags.pollErr`  - an error has occurred.
- `PollFlags.none`     - no events have occurred.

Note that the poller will continue to report `pollIn` until `recv` has been
called to retrieve all stored messages. Likewise `pollOut` will always be
returned until the socket is no longer able to send messages.
