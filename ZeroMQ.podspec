
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

  s.ios.deployment_target = "8.0"

  s.source         = {
    :git => "https://github.com/azawawi/ZeroMQ.git",
    :tag => "#{s.version}"
  }
  s.source_files   = "ZeroMQ/*.swift"
  s.libraries      = 'stdc++'
  s.xcconfig       = {
    "SWIFT_INCLUDE_PATH"   => "${SRC_ROOT)/ZeroMQ",
    "LIBRARY_SEARCH_PATHS" => "$(SRC_ROOT)/ZeroMQ"
  }
  s.ios.vendored_libraries = "ZeroMQ/libzmq1.a"
  s.preserve_paths = "ZeroMQ/module.modulemap"

end
