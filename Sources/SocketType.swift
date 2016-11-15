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

        - Request-reply pattern (`.request`, `.reply`, `.router`, `.dealer`):

            The request-reply pattern is used for sending requests from a
            `.request` client to one or more `.reply` services, and receiving
            subsequent replies to each request sent. The request-reply pattern
            is formally defined [here](http://rfc.zeromq.org/spec:28).

        - Publish-subscribe pattern (`.publish`, `.subscribe`, `.xpublish`,
          `.xsubscribe`):

            The publish-subscribe pattern is used for one-to-many distribution
            of data from a single publisher to multiple subscribers in a fan out
            fashion. The publish-subscribe pattern is formally defined
            [here](http://rfc.zeromq.org/spec:29).

        - Pipeline pattern (`.push`, `.pull`):

            The pipeline pattern is used for distributing data to nodes arranged
            in a pipeline. Data always flows down the pipeline, and each stage
            of the pipeline is connected to at least one node. When a pipeline
            stage is connected to multiple nodes data is round-robined among all
            connected nodes. The pipeline pattern is formally defined
            [here](http://rfc.zeromq.org/spec:30).

        - Exclusive pair pattern (`.pair`):

            The exclusive pair pattern is used to connect a peer to precisely
            one other peer. This pattern is used for inter-thread communication
            across the inproc transport. The exclusive pair pattern is formally
            defined [here](http://rfc.zeromq.org/spec:31).

        - Native pattern (`.stream`):

            The native pattern is used for communicating with TCP peers and
            allows asynchronous requests and replies in either direction.
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
            then any `socket.send` operations on the socket shall block until
            the mute state ends or at least one peer becomes available for
            sending; **messages are not discarded**.

            When a .dealer socket is connected to a .reply socket each
            message sent must consist of an empty message part, the delimiter,
            followed by one or more body parts
         */
        case dealer
        /**
            A socket of type `.router` is an advanced socket type used for
            extending request/reply sockets. When receiving messages a `.router`
            socket shall prepend a message part containing the identity of the
            originating peer to the message before passing it to the
            application. Messages received are fair-queued from among all
            connected peers. When sending messages a `.router` socket shall
            remove the first part of the message and use it to determine the
            identity of the peer the message shall be routed to. If the peer
            does not exist anymore the message shall be silently discarded by
            default, unless `(set|get)RouterMandatory` socket option is set to
            1.

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
            A socket of type `.publish` is used by a publisher to distribute
            data. Messages sent are distributed in a fan out fashion to all
            connected peers. **The `socket.recv` method is not implemented for
            this socket type.**

            When a `.publish` socket enters the mute state due to having reached
            the high water mark for a subscriber, then any messages that would
            be sent to the subscriber in question shall instead be dropped until
            the mute state ends. **The `socket.send` method shall never block
            for this socket type.**
         */
        case publish
        /**
            A socket of type `.subscribe` is used by a subscriber to subscribe
            to data distributed by a publisher. Initially a `.subscribe` socket
            is not subscribed to any messages, use the `.setSubscribe` method to
            specify  which messages to subscribe to. **The `socket.send` method
            is not implemented for this socket type.**
         */
        case subscribe
        /**
            Same as `.publish` except that you can receive subscriptions from
            the peers in form of incoming messages. Subscription message is a
            byte 1 (for subscriptions) or byte 0 (for unsubscriptions) followed
            by the subscription body. Messages without a sub/unsub prefix are
            also received, but have no effect on subscription status.
         */
        case xpublish
        /**
            Same as `.subscribe` except that you subscribe by sending
            subscription messages to the socket. Subscription message is a byte
            1 (for subscriptions) or byte 0 (for unsubscriptions) followed by
            the subscription body. Messages without a sub/unsub prefix may also
            be sent, but have no effect on subscription status.
         */
        case xsubscribe

        // Pipeline pattern
        /**
            A socket of type `.push` is used by a pipeline node to send
            messages to downstream pipeline nodes. Messages are round-robined to
            all connected downstream nodes. **The `socket.recv` method is not
            implemented for this socket type.**

            When a `.push` socket enters the mute state due to having reached
            the high water mark for all downstream nodes, or if there are no
            downstream nodes at all, then any `socket.send` operations on the
            socket shall block until the mute state ends or at least one
            downstream node becomes available for sending; messages are not
            discarded
         */
        case push
        /**
            A socket of type `.pull` is used by a pipeline node to receive
            messages from upstream pipeline nodes. Messages are fair-queued from
            among all connected upstream nodes. **The `socket.send` method is
            not implemented for this socket type.**
         */
        case pull

        // Exclusive pair pattern
        /**
            A socket of type `.pair` can only be connected to a single peer at
            any one time. No message routing or filtering is performed on
            messages sent over a `.pair` socket.

            When a `.pair` socket enters the mute state due to having reached
            the high water mark for the connected peer, or if no peer is
            connected, then any `socket.send` operations on the socket shall
            block until the peer becomes available for sending; messages are not
            discarded.

            **Note:** ZMQ_PAIR sockets are designed for inter-thread
            communication across the `inproc://` transport and do not
            implement functionality such as auto-reconnection.
         */
        case pair

        // Native pattern
        /**
            A socket of type `.stream` is used to send and receive TCP data
            from a non-ØMQ peer, when using the tcp:// transport. A `.stream`
            socket can act as client and/or server, sending and/or receiving TCP
            data asynchronously.

            When receiving TCP data, a `.stream` socket shall prepend a message
            part containing the identity of the originating peer to the message
            before passing it to the application. Messages received are
            fair-queued from among all connected peers.

            When sending TCP data, a `.stream` socket shall remove the first
            part of the message and use it to determine the identity of the peer
            the message shall be routed to, and unroutable messages shall cause
            an `EHOSTUNREACH` or `EAGAIN` error.

            To open a connection to a server, use the `.connect` method call,
            and then fetch the socket identity using the `getIdentity` method
            call.

            To close a specific connection, send the identity frame followed by
            a zero-length message.

            When a connection is made, a zero-length message will be received by
            the application. Similarly, when the peer disconnects (or the
            connection is lost), a zero-length message will be received by the
            application.

            The `SocketSendRecvOption.sendMore` flag is ignored on data frames.
            You must send one identity frame followed by one data frame.

            Also, please note that omitting the `SocketSendRecvOption.sendMore`
            flag will prevent sending further data (from any client) on the same
            socket.
         */
        case stream

        /**
            This is a workaround to return dynamically loaded native `ZMQ_`
            constants
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
