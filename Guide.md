# User Guide

TODO document user guide intro

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

### Version

To get the ZeroMQ library version, please type:

```swift
// Version as a tuple
let (major, minor, patch) = SwiftyZeroMQ.version
print("ZeroMQ library version is \(major).\(minor).\(patch)")

// Version as a string
let versionString = SwiftyZeroMQ.versionString
print("ZeroMQ library version is \(versionString)")
```
