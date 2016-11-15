//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

extension SwiftyZeroMQ {

    /**
        An enumeration of socket send and receive options that map out to a
        32-bit integer
     */
    public enum SocketSendRecvOption : Int32 {
        case none
        case dontWait
        case sendMore
        case dontWaitSendMore

        /**
            This is a workaround to return dynamically loaded ZMQ_ constants
         */
        public var rawValue: Int32 {
            switch self {
                case .none:              return 0
                case .dontWait:          return ZMQ_DONTWAIT
                case .sendMore:          return ZMQ_SNDMORE
                case .dontWaitSendMore:  return ZMQ_DONTWAIT | ZMQ_SNDMORE
            }
        }

        /**
            Returns whether the current option is a valid receive option or not
         */
        public func isValidRecvOption() -> Bool {
            return self == .none || self == .dontWait
        }
    }

}
