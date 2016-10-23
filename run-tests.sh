#!/bin/bash

command_exists () {
  type "$1" &> /dev/null
}

# Check whether xcpretty is installed
if ! command_exists xcpretty; then
  echo "xcpretty not found. Please run 'gem install xcpretty'."
  exit 1
fi

DESTINATION='platform=iOS Simulator,name=iPhone 6,OS=10.0'

echo "Running 'xcodebuild test' for $DESTINATION. Please wait..."
xcodebuild \
  -project SwiftyZeroMQ.xcodeproj \
  -scheme SwiftyZeroMQ \
  -sdk iphonesimulator \
  -destination "$DESTINATION" \
  -verbose test | xcpretty
