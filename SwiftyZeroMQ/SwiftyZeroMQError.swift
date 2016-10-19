//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import CZeroMQ

/*
    This provides a clean way to get the ZMQ library errors. This is usually
    thrown when a -1 result is returned from a LibZMQ library function
 */
public struct SwiftyZeroMQError : Error, CustomStringConvertible {
    public let description: String

    /*
        Returns the last ZMQ library error with a string error description
     */
    public static var last : SwiftyZeroMQError {
        let errorCString = zmq_strerror(zmq_errno())!
        let description = String(validatingUTF8: errorCString)!
        return SwiftyZeroMQError(description: description)
    }

    public static var invalidOption : SwiftyZeroMQError {
        return SwiftyZeroMQError(description: "Invalid option")
    }

    public static var unimplemented : SwiftyZeroMQError {
        return SwiftyZeroMQError(description: "Unimplemented at the moment. PRs are welcome")
    }

}
