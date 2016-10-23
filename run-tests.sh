#!/bin/bash

DESTINATION='platform=iOS Simulator,name=iPhone 6,OS=10.0'

echo "Running 'xcodebuild test' for $DESTINATION. Please wait..."
xcodebuild \
  -project SwiftyZeroMQ.xcodeproj \
  -scheme SwiftyZeroMQ \
  -sdk iphonesimulator \
  -destination "$DESTINATION" \
  -verbose \
  test
