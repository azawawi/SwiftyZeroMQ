#!/bin/bash

command_exists () {
  type "$1" &> /dev/null
}

run_tests() {
  echo "Running 'xcodebuild test' for $1. Please wait..."

  xcodebuild \
    -project SwiftyZeroMQ.xcodeproj \
    -scheme SwiftyZeroMQ \
    -sdk iphonesimulator \
    -destination "$1" \
    -verbose test | xcpretty
}

# Check whether xcpretty is installed
if ! command_exists xcpretty; then
  echo "xcpretty not found. Please run 'gem install xcpretty'."
  exit 1
fi

# Test on iPhone 5 (multiple iOS versions)
run_tests 'platform=iOS Simulator,name=iPhone 5,OS=9.0'
run_tests 'platform=iOS Simulator,name=iPhone 5,OS=10.0'
