//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

extension SwiftyZeroMQ {

    /**
        An enumeration of ZeroMQ socket types that maps to a signed 32-bit
        integer. This provides the following patterns:

        - Request-reply pattern: `.request`, `.reply`, `.router`, `.dealer`
        - Publish-subscribe pattern: `.publish`, `.subscribe`, `.xpublish`,
          `.xsubscribe`
        - Pipeline pattern: `.push`, `.pull`
        - Exclusive pair pattern: `.pair`
        - Native pattern: `.stream`
     */
    public enum SocketType : Int32 {
        // Request-reply pattern
        /**
            A socket of type `.request` is used by a client to send requests to
            and receive replies from a service. This socket type allows only an
            alternating sequence of `send(request)` and subsequent `recv(reply)`
            calls. Each request sent is round-robined among all services, and
            each reply received is matched with the last issued request.

            If no services are available, then any send operation on the socket
            shall block until at least one service becomes available. The
            `.request` socket shall not discard messages.
         */
        case request
        /**
            A socket of type `.reply` is used by a service to receive requests
            from and send replies to a client. This socket type allows only an
            alternating sequence of `.recv(request)` and subsequent
            `send(reply)` calls. Each request received is fair-queued from
            among all clients, and each reply sent is routed to the client that
            issued the last request. **If the original requester does not exist
            any more the reply is silently discarded.**
         */
        case reply
        /**
            A socket of type `.dealer` is an advanced pattern used for
            extending request/reply sockets. Each message sent is round-robined
            among all connected peers, and each message received is fair-queued
            from all connected peers.

            When a `.dealer` socket enters the mute state due to having reached
            the high water mark for all peers, or if there are no peers at all,
            then any `.send` operations on the socket shall block until the
            mute state ends or at least one peer becomes available for sending;
            **messages are not discarded**.

            When a .dealer socket is connected to a .reply socket each
            message sent must consist of an empty message part, the delimiter,
            followed by one or more body parts
         */
        case dealer
        /**
            A socket of type `.router` is an advanced socket type used for
            extending request/reply sockets. When receiving messages a
            `.router` socket shall prepend a message part containing the
            identity of the originating peer to the message before passing it to
            the application. Messages received are fair-queued from among all
            connected peers. When sending messages a `.router` socket shall
            remove the first part of the message and use it to determine the
            identity of the peer the message shall be routed to. If the peer
            does not exist anymore the message shall be silently discarded by
            default, unless `routerMandatory` socket option is set to 1.

            When a `.router` socket enters the mute state due to having reached
            the high water mark for all peers, then any messages sent to the
            socket shall be dropped until the mute state ends. Likewise, any
            messages routed to a peer for which the individual high water mark
            has been reached shall also be dropped.

            When a `.request` socket is connected to a `.router` socket, in
            addition to the identity of the originating peer each message
            received shall contain an empty delimiter message part. Hence, the
            entire structure of each received message as seen by the application
            becomes: one or more identity parts, delimiter part, one or more
            body parts. When sending replies to a `.request` socket the
            application must include the delimiter part.
         */
        case router

        // Publish-subscribe pattern
        /**
         */
        case publish
        /**
         */
        case subscribe
        /**
         */
        case xpublish
        /**
         */
        case xsubscribe

        // Pipeline pattern
        /**
         */
        case push
        /**
          */
        case pull

        // Exclusive pair pattern
        /**
         */
        case pair

        // Native pattern
        /**
         */
        case stream

        /**
            This is a workaround to return dynamically loaded ZMQ_ constants
         */
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
