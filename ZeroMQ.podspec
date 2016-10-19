
Pod::Spec.new do |s|

  s.name         = "ZeroMQ"
  s.version      = "1.0.0"
  s.summary      = "ZeroMQ Swift Bindings for iOS."
  s.description  = <<-DESC
                        This project provides iOS Swift bindings for the ZeroMQ
                        C library.
                   DESC
  s.homepage     = "https://github.com/azawawi/ZeroMQ"
  s.license      = "MIT"
  s.author       = { "Ahmad M. Zawawi" => "ahmad.zawawi@gmail.com" }

  s.ios.deployment_target = "10.0"

  s.source         = {
    :git => "https://github.com/azawawi/ZeroMQ.git",
    :tag => "#{s.version}"
  }
  s.libraries      = "stdc++"
  s.xcconfig       = {
# "HEADER_SEARCH_PATHS"  => "${SRCROOT}/ZeroMQ",
    "SWIFT_INCLUDE_PATH"   => "${PROJECT_ROOT)/ZeroMQ",
    "LIBRARY_SEARCH_PATHS" => "$(PROJECT_ROOT)/ZeroMQ",
    "ENABLE_BITCODE"       => "NO"
  }

  s.module_name        = "ZeroMQ"
  s.default_subspecs   = "ZeroMQ"

  s.subspec "ZeroMQ" do |ss|
    ss.source_files = "ZeroMQ/*.swift", "ZeroMQ/*.h"
    ss.dependency "ZeroMQ/CZeroMQ"
  end

  s.subspec "CZeroMQ" do |ss|
    ss.source_files       = "CZeroMQ/*.h"
    ss.vendored_libraries = "CZeroMQ/libzmq.a"
    ss.preserve_paths     = "CZeroMQ/*"
  end
  #s.module_map     = "ZeroMQ/module.modulemap"
  #s.preserve_paths = "ZeroMQ/module.modulemap", "ZeroMQ/libzmq.a", "ZeroMQ/zmq.h"

end
