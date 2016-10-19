
Pod::Spec.new do |s|

  s.name         = "SwiftyZeroMQ"
  s.version      = "1.0.4"
  s.summary      = "ZeroMQ Swift Bindings for iOS."
  s.description  = <<-DESC
                        This project provides iOS Swift bindings for the ZeroMQ
                        C library.
                   DESC
  s.homepage     = "https://github.com/azawawi/SwiftyZeroMQ"
  s.license      = "MIT"
  s.author       = { "Ahmad M. Zawawi" => "ahmad.zawawi@gmail.com" }

  s.source         = {
    :git => "https://github.com/azawawi/SwiftyZeroMQ.git",
    :tag => "#{s.version}"
  }

  s.module_name           = "SwiftyZeroMQ"
  s.default_subspecs      = "SwiftyZeroMQ"
  s.ios.deployment_target = "10.0"
  s.libraries             = "stdc++"

  s.subspec "SwiftyZeroMQ" do |ss|
    ss.source_files = "SwiftyZeroMQ/*.swift"
    ss.dependency     "SwiftyZeroMQ/CZeroMQ"
  end

  s.subspec "CZeroMQ" do |ss|
    ss.source_files       = "CZeroMQ/*.h"
    ss.vendored_libraries = "CZeroMQ/libzmq.a"
    ss.preserve_paths     = "CZeroMQ/*"
    ss.xcconfig           = {
      "SWIFT_INCLUDE_PATH"   => "${PROJECT_ROOT)/CZeroMQ",
      "ENABLE_BITCODE"       => "NO"
    }
  end

end
