
Pod::Spec.new do |s|
  s.name                  = "SwiftyZeroMQ"
  s.version               = "1.0.20"
  s.summary               = "ZeroMQ Swift Bindings for iOS."
  s.description           = <<-DESC
    This library provides easy-to-use iOSiOS, macOS, tvOS and watchOS Swift
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
  s.ios.deployment_target     = "9.0"
  s.osx.deployment_target     = "10.11"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"
  s.libraries                 = "stdc++"
  s.source_files              = "Sources/*.{h,swift}"
  s.vendored_libraries        = "Sources/libzmq-{ios,macos,tvos,watchos}.a"
  s.preserve_paths            = "Sources/*.{a,h}"
end
