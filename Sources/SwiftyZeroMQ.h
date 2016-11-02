//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

// Provides target conditional macros
#import "TargetConditionals.h"

// Import appropriate library depending on target being macOS or iOS/tvOS/watchOS
#if TARGET_OS_MAC
    #import <Cocoa/Cocoa.h>
#else
    #import <UIKit/UIKit.h>
#endif

// Import libzmq functions and constants into Swift
#import "zmq.h"

//! Project version number for SwiftySwiftyZeroMQ.
FOUNDATION_EXPORT double SwiftyZeroMQVersionNumber;

//! Project version string for SwiftySwiftyZeroMQ.
FOUNDATION_EXPORT const unsigned char SwiftyZeroMQVersionString[];
