#!/usr/bin/env ruby

#
# Cross-platform way of finding an executable in the $PATH. Returns nil on
# failure
# Reference: http://stackoverflow.com/questions/2108727
#
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    }
  end

  return nil
end

# Run iOS test for simulator destination
def run_tests(destination)
  puts "Running 'xcodebuild test' for #{destination}. Please wait..."

  ret = system("xcodebuild " +
    "-project SwiftyZeroMQ.xcodeproj " +
    "-scheme SwiftyZeroMQ " +
    "-sdk iphonesimulator " +
    "-destination \"#{destination}\" " +
    "-verbose test | xcpretty")
  if ret != 0
    puts "Failed while executing command"
    exit 1
  end
end

# Check whether xcpretty is installed
if which("xcpretty") == nil then
  echo "xcpretty not found. Please run 'gem install xcpretty'."
  exit 1
end

# Test on iPhone 5 (multiple iOS versions)
run_tests 'platform=iOS Simulator,name=iPhone 5,OS=9.0'
run_tests 'platform=iOS Simulator,name=iPhone 5,OS=10.0'
