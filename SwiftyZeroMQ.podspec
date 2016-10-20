
Pod::Spec.new do |s|

  s.name         = "SwiftyZeroMQ"
  s.version      = "1.0.10"
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

  s.ios.deployment_target = "10.0"
  s.libraries             = "stdc++"
  s.source_files          = "SwiftyZeroMQ/*.{h,swift}"
  s.vendored_libraries    = "SwiftyZeroMQ/libzmq.a"
  s.preserve_paths        = "SwiftyZeroMQ/*.{a,h}"

end
