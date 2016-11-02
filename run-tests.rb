#!/usr/bin/env ruby

#
# Cross-platform way of finding an executable in the $PATH. Returns nil on
# failure
# Reference: http://stackoverflow.com/questions/2108727
#
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    end
  end
  return nil
end

# Run test for simulator destination
def run_tests(scheme, sdk, destination, action='test')
  puts "Running 'xcodebuild test' for '#{scheme}, #{sdk}, #{destination}'. Please wait..."

  # Build or run framework test (if needed) in debug and release configurations
  for configuration in ["Debug", "Release"]
    command = [
      "xcodebuild",
      "-project SwiftyZeroMQ.xcodeproj",
      "-scheme #{scheme}",
      "-sdk #{sdk}",
      "-destination '#{destination}'",
      "-configuration #{configuration}",
      "-verbose #{action} | xcpretty -c"
    ].join(" ")
    ret = system(command)
    if !ret
      puts "Failed while executing '#{command}'"
      exit 1
    end
  end
end

if /darwin/ !~ RUBY_PLATFORM
  puts "This script needs macOS to run"
  exit 1
end

# Check whether xcpretty is installed
if which("xcpretty") == nil then
  puts "xcpretty not found. Please run 'gem install xcpretty'."
  exit 1
end

# Run iOS tests
scheme = 'SwiftyZeroMQ-iOS'
sdk    = 'iphonesimulator10.0'
run_tests(scheme, sdk, 'platform=iOS Simulator,name=iPhone 5,OS=9.0')
run_tests(scheme, sdk, 'platform=iOS Simulator,name=iPhone 5,OS=10.0')

# Run macOS tests
scheme = 'SwiftyZeroMQ-macOS'
sdk    = 'macosx10.12'
run_tests(scheme, sdk, 'arch=x86_64')

# Run tvOS tests
scheme = 'SwiftyZeroMQ-tvOS'
sdk    = 'appletvsimulator10.0'
run_tests(scheme, sdk, 'OS=9.0,name=Apple TV 1080p')
run_tests(scheme, sdk, 'OS=10.0,name=Apple TV 1080p')

# Only build watchOS since it does not support testing at the moment
scheme = 'SwiftyZeroMQ-tvOS'
sdk    = 'watchsimulator3.0'
run_tests(scheme, sdk, 'OS=2.0,name=Apple Watch - 42mm', 'build')
run_tests(scheme, sdk, 'OS=3.0,name=Apple Watch - 42mm', 'build')
