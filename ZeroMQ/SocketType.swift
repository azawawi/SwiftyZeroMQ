//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import LibZMQ

extension ZMQ {

    public enum SocketType : Int32 {
        // Request-reply pattern
        case request
        case reply
        case router
        case dealer

        // Publish-subscribe pattern
        case publish
        case subscribe
        case xpublish
        case xsubscribe

        // Pipeline pattern
        case push
        case pull

        // Exclusive pair pattern
        case pair

        // Native pattern
        case stream

        // This is a workaround to return dynamically loaded ZMQ_ constants
        public var rawValue: Int32 {
            switch self {
                // Request-reply pattern
                case .request:  return ZMQ_REQ
                case .reply:    return ZMQ_REP
                case .router:   return ZMQ_ROUTER
                case .dealer:   return ZMQ_DEALER

                // Publish-subscribe pattern
                case .publish:    return ZMQ_PUB
                case .subscribe:  return ZMQ_SUB
                case .xpublish:   return ZMQ_XPUB
                case .xsubscribe: return ZMQ_XSUB

                // Pipeline pattern
                case .push:   return ZMQ_PUSH
                case .pull:   return ZMQ_PULL

                // Exclusive pair pattern
                case .pair:   return ZMQ_PAIR

                // Native pattern
                case .stream: return ZMQ_STREAM
            }
        }
    }

}
