
Pod::Spec.new do |s|
  s.name                  = "SwiftyZeroMQ"
  s.version               = "1.0.25"
  s.summary               = "ZeroMQ Swift Bindings for iOS, macOS, tvOS and watchOS."
  s.description           = <<-DESC
    This library provides easy-to-use iOS, macOS, tvOS and watchOS Swift
    bindings for the ZeroMQ C++ library. It is written in Swift 3 and features a
    bundled stable libzmq library. It provides ZeroMQ's low-level API along with
    an object-oriented API.
                               DESC
  s.homepage              = "https://github.com/azawawi/SwiftyZeroMQ"
  s.license               = "MIT"
  s.author                = {
    "Ahmad M. Zawawi" => "ahmad.zawawi@gmail.com"
  }
  s.source                = {
    :git => "https://github.com/azawawi/SwiftyZeroMQ.git",
    :tag => "#{s.version}"
  }
  s.ios.deployment_target      = "9.0"
  s.osx.deployment_target      = "10.11"
  s.tvos.deployment_target     = "9.0"
  s.watchos.deployment_target  = "2.0"
  s.libraries                  = "c++"
  s.source_files               = "Sources/*.{h,swift}"
  s.ios.vendored_libraries     = "Libraries/libzmq-ios.a"
  s.osx.vendored_libraries     = "Libraries/libzmq-macos.a"
  s.tvos.vendored_libraries    = "Libraries/libzmq-tvos.a"
  s.watchos.vendored_libraries = "Libraries/libzmq-watchos.a"
  s.preserve_paths             = "Sources/*.{a,h}"
end
