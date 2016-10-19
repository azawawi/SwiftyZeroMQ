
Pod::Spec.new do |s|

  s.name         = "ZeroMQ"
  s.version      = "1.0.0"
  s.summary      = "ZeroMQ Swift Bindings for iOS."
  s.description  = <<-DESC
                        This package provides Swift API bindings for the famous
                        ZeroMQ library for iOS.

                        **Note: At the moment, please consider the project experimental.**
                   DESC
  s.homepage     = "https://github.com/azawawi/ZeroMQ"
  s.license      = "MIT"
  s.author             = { "Ahmad M. Zawawi" => "ahmad.zawawi@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/azawawi/ZeroMQ.git", :tag => "#{s.version}" }
  s.source_files  = "ZeroMQ/*.{swift,h,modulemap}"

end
