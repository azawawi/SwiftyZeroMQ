
Pod::Spec.new do |s|

  s.name         = "ZeroMQ"
  s.version      = "1.0.2"
  s.summary      = "ZeroMQ Swift Bindings for iOS."
  s.description  = <<-DESC
                        This project provides iOS Swift bindings for the ZeroMQ
                        C library.
                   DESC
  s.homepage     = "https://github.com/azawawi/ZeroMQ"
  s.license      = "MIT"
  s.author       = { "Ahmad M. Zawawi" => "ahmad.zawawi@gmail.com" }

  s.source         = {
    :git => "https://github.com/azawawi/ZeroMQ.git",
    :tag => "#{s.version}"
  }

  s.module_name           = "ZeroMQ"
  s.default_subspecs      = "ZeroMQ"
  s.ios.deployment_target = "10.0"
  s.libraries             = "stdc++"

  s.subspec "ZeroMQ" do |ss|
    ss.source_files = "ZeroMQ/*.swift"
    ss.dependency     "ZeroMQ/CZeroMQ"
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
