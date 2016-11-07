//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

extension SwiftyZeroMQ {

    /**
        This represents poll flags and is used in `register` and `modify`
     */
    public struct PollFlags : OptionSet {
        public var rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        static let pollIn          = PollFlags(rawValue: ZMQ_POLLIN)
        static let pollOut         = PollFlags(rawValue: ZMQ_POLLOUT)
        static let pollErr         = PollFlags(rawValue: ZMQ_POLLERR)
        static let none: PollFlags = []
    }

    /**
        This represents a ZeroMQ poller implementation
     */
    public class Poller {
        private var sockets: [(Socket, PollFlags)]
        private var socketMap: [Socket:Int]

        public init() {
            sockets = [(Socket, PollFlags)]()
            socketMap = [Socket:Int]()
        }

        /**
          Register a socket for the given flags
        */
        public func register(socket: Socket, flags: PollFlags = [.pollIn, .pollOut]) throws {
            // if there are any flags, update or add the socket as necessary
            if flags != PollFlags.none {
                if let ix = self.socketMap[socket] {
                    self.sockets[ix] = (socket, flags)
                } else {
                    let ix = sockets.count
                    self.sockets.append((socket, flags))
                    self.socketMap[socket] = ix
                }
            }
            // if no flags but currently registered then unregister
            else if (self.socketMap[socket] != nil) {
                try self.unregister(socket: socket)
            }

            // if socket not currently registered and no flags supplied then do nothing

        }

        /**
          Modify a socket registration. This is equivalent to calling
          `register(socket, flags)`
        */
        public func modify(socket: Socket, flags: PollFlags = [.pollIn, .pollOut]) throws {
            // thin wrapper for register
            try self.register(socket: socket, flags: flags)
        }

        /**
          Unregister the supplied socket
        */
        public func unregister(socket: Socket) throws {
            let ix = self.socketMap[socket]!
            self.sockets.remove(at: ix)

            // update indices of all other sockets in the socket map
            for (socket, _) in sockets.suffix(from: ix) {
                let socketIx = self.socketMap[socket]!
                self.socketMap[socket] = socketIx - 1
            }
        }

        /**
            Poll the register socket(s) for events
         */
        public func poll(timeout: TimeInterval? = nil) throws -> [Socket: PollFlags] {
            // TODO is there a more swifty way of doing this?
            var intTimeout : Int
            if timeout == nil {
                intTimeout = -1
            } else {
                intTimeout = Int(timeout!)
            }

            // now poll
            let pollItems = Poller.constructPollItems(sockets: self.sockets)
            let code = zmq_poll(pollItems, Int32(self.sockets.count), intTimeout)

            // if code is negative raise the appropriate error
            if code < 0 {
                pollItems.deallocate(capacity: self.sockets.count)
                throw ZeroMQError.last
            }
            // construct return type
            let ret = Poller.constructReturn(sockets: self.sockets, pollItems: pollItems)
            pollItems.deallocate(capacity: self.sockets.count)
            return ret
        }

        /**
          Construct return type given sockets
        */
        private static func constructReturn(sockets: [(Socket, PollFlags)],
                                            pollItems: UnsafeMutablePointer<zmq_pollitem_t>)
            -> [Socket: PollFlags]
        {
            // assumes that sockets and poll items are in the same order
            var ret = [Socket: PollFlags]()
            for (ix, (socket, _)) in sockets.enumerated() {
                let pollItem      = pollItems[ix]
                let receivedFlags = PollFlags(rawValue: Int32(pollItem.revents))
                ret[socket]       = receivedFlags
            }
            return ret
        }

        /**
          Construct poll items from a supplied list of socket flags
        */
        private static func constructPollItems(sockets: [(Socket, PollFlags)]) -> UnsafeMutablePointer<zmq_pollitem_t> {
            let pollItems = UnsafeMutablePointer<zmq_pollitem_t>.allocate(capacity: sockets.count)
            for (ix, (socket, flags)) in sockets.enumerated() {
                var pollItem    = zmq_pollitem_t()
                pollItem.socket = socket.handle
                pollItem.events = Int16(flags.rawValue)
                pollItems[ix]   = pollItem
            }
            return pollItems
        }
    }

}
