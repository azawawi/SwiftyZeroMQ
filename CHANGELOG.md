# Change Log

All changes to this framework is documented here in chronological order (latest first).

- 1.0.15
  - ...
  - Add change log

- 1.0.14
  - Fix `clock_gettime` crash in `testSocket` test case on pre-iOS 10  (i.e. iOS 8.1 and 9)

- 1.0.13
  - Enable Bitcode in `libzmq.a` and XCode project.
  - More documentation updates.
  - Add a bash shell script to run Xcode tests using the terminal via an `xcpretty` filter.

- 1.0.12
  - Fix iOS 8+ compatibility for `armv7` and `armv7s`.
  - More documentation about the bundled `libzmq.a`.

- 1.0.11
  - Added iOS 8+ support

- 1.0.10
  - Fix CocoaPods support is now working as intended.
  - Remove `CZeroMQ` module map.
  - Expose native `zmq.h` C API when importing `SwiftyZeroMQ`.

- 1.0.9 **Pre-release**
  - Attempt to fix CocoaPods module map but really that went no where.

- 1.0.8
  - Disable [Bitcode](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html)
  - Added [Carthage](https://github.com/Carthage/Carthage) integration
  - Various documentation fixes

- 1.0.7
  - Disable Bitcode in the Xcode project

- 1.0.6 **Pre-release**
  - This is an initial release with CocoaPods support to provide out of the box iOS ZeroMQ bindings.

- 1.0.5 **Pre-release**
  - Make SwiftyZeroMQ schema shared for future Carthage support

- 1.0.4 **Pre-release**
  - More refactoring

- 1.0.3 **Pre-release**
  - More refactoring and experimentation

- 1.0.2 **Pre-release**
  - More refactoring and experimentation

- 1.0.1 **Pre-release**
  - More refactoring and experimentation

- 1.0.0 **Pre-release**
  - First experimental release
