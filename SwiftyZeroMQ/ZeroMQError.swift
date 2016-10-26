//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

/*
    This provides a clean way to get the ZMQ library errors. This is usually
    thrown when a -1 result is returned from a LibZMQ library function
 */

extension SwiftyZeroMQ {

    public struct ZeroMQError : Error, CustomStringConvertible {
        public let description: String
      
        /*
            Returns the last ZMQ library error with a string error description
         */
        public static var last : ZeroMQError {
            let errorCString = zmq_strerror(zmq_errno())!
            let description = String(validatingUTF8: errorCString)!
            return ZeroMQError(description: description)
        }

        /*
          Return an invalid option error
         */
        public static var invalidOption : ZeroMQError {
            return ZeroMQError(description: "Invalid option")
        }

        /*
          Returns an unimplemented error
         */
        public static var unimplemented : ZeroMQError {
            return ZeroMQError(
              description: "Unimplemented at the moment. PRs are welcome")
        }
    }

}
