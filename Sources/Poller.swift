//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

extension SwiftyZeroMQ {

    /**
        This represents the poll flags and is used in `register` and `modify`
     */
    public struct PollFlags : OptionSet {
        public var rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        // Poll flags
        public static let pollIn            = PollFlags(rawValue: ZMQ_POLLIN)
        public static let pollOut           = PollFlags(rawValue: ZMQ_POLLOUT)
        public static let pollErr           = PollFlags(rawValue: ZMQ_POLLERR)
        public static let `none`: PollFlags = []
    }

    /**
        This represents a ZeroMQ poller implementation which provides socket
        I/O multiplexing
     */
    public class Poller {
        private var sockets   : [(Socket, PollFlags)]
        private var socketMap : [Socket:Int]

        /**
            Creates a new Poller object
         */
        public init() {
            sockets   = [(Socket, PollFlags)]()
            socketMap = [Socket:Int]()
        }

        /**
            Register a socket for the given flags
            If no flags are supplied, it will unregister the socket
         */
        public func register(
            socket: Socket,
            flags: PollFlags = [.pollIn, .pollOut])
            throws
        {
            if flags != PollFlags.none {
                // if there are any flags, update or add the socket as needed
                if let socketIndex  = socketMap[socket] {
                    sockets[socketIndex] = (socket, flags)
                } else {
                    let socketIndex        = sockets.count
                    sockets.append((socket, flags))
                    socketMap[socket] = socketIndex
                }
            } else if (socketMap[socket] != nil) {
                // if no flags were supplied but currently registered then
                // unregister socket
                try unregister(socket: socket)
            }

            // if socket is not currently registered and no flags were supplied
            // then do nothing
        }

        /**
            Modify a socket registration. This is equivalent to calling
            `register(socket, flags)`
         */
        public func modify(
            socket : Socket,
            flags  : PollFlags = [.pollIn, .pollOut]) throws
        {
            try register(socket: socket, flags: flags)
        }

        /**
            Unregister the supplied socket
         */
        public func unregister(socket: Socket) throws {
            let socketIndex = socketMap[socket]!
            sockets.remove(at: socketIndex)

            // Update indices of all other sockets in the socket map
            for (socket, _) in sockets.suffix(from: socketIndex) {
                let socketIndex = socketMap[socket]!
                socketMap[socket] = socketIndex - 1
            }
        }

        /**
            Poll the registered socket(s) for events
         */
        public func poll(timeout: TimeInterval? = nil) throws
            -> [Socket: PollFlags]
        {
            // Now start polling
            let pollItems = buildPollItems()

            defer {
              // Clean up poll items on scope exit
              pollItems.deallocate()
            }

            let intTimeout = (timeout == nil)
                ? -1
                : Int(timeout!)
            let code = zmq_poll(pollItems, Int32(sockets.count),
              intTimeout)

            if code < 0 {
                // if code is negative, cleanup poll items before
                // throwing an error
                throw ZeroMQError.last
            }

            // Build hash map [Socket: PollFlags]
            let map = buildSocketPollFlagsMap(pollItems : pollItems)

            return map
        }

        /**
            Build socket to poll flags map from provided sockets and poll items
         */
        private func buildSocketPollFlagsMap(
            pollItems : UnsafeMutablePointer<zmq_pollitem_t>
        ) -> [Socket: PollFlags]
        {
            // Assumption: sockets and poll items are in the same order
            var map = [Socket: PollFlags]()
            for (socketIndex, (socket, _)) in sockets.enumerated() {
                let pollItem      = pollItems[socketIndex]
                let receivedFlags = PollFlags(rawValue: Int32(pollItem.revents))
                map[socket]       = receivedFlags
            }
            return map
        }

        /**
            Build poll items from a supplied list of socket flags
         */
        private func buildPollItems() -> UnsafeMutablePointer<zmq_pollitem_t>
        {
            let pollItems = UnsafeMutablePointer<zmq_pollitem_t>.allocate(
              capacity: sockets.count
            )
            for (socketIndex, (socket, flags)) in sockets.enumerated() {
                var pollItem           = zmq_pollitem_t()
                pollItem.socket        = socket.handle
                pollItem.events        = Int16(flags.rawValue)
                pollItems[socketIndex] = pollItem
            }
            return pollItems
        }
    }

}
