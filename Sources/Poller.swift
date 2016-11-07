//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

extension SwiftyZeroMQ {
    public struct PollFlags : OptionSet {
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        public var rawValue: Int32
        
        static let pollIn = PollFlags(rawValue: ZMQ_POLLIN)
        static let pollOut = PollFlags(rawValue: ZMQ_POLLOUT)
        static let pollErr = PollFlags(rawValue: ZMQ_POLLERR)
        
        static let none: PollFlags = []
    }
    
    /**
        This is placeholder for Poller. This is currently not implemented

        TODO implement Poller
     */
    public class Poller {
        private var _sockets: [(Socket, PollFlags)]
        private var _socketMap: [Socket:Int]
        
        public init() {
            _sockets = [(Socket, PollFlags)]()
            _socketMap = [Socket:Int]()
        }
        
        /**
         Register a socket for the given flags
        */
        public func register(socket: Socket, flags: PollFlags = [.pollIn, .pollOut]) throws {
            // if there are any flags, update or add the socket as necessary
            if flags != PollFlags.none {
                if let ix = self._socketMap[socket] {
                    self._sockets[ix] = (socket, flags)
                }
                else {
                    let ix = _sockets.count
                    self._sockets.append((socket, flags))
                    self._socketMap[socket] = ix
                }
            }
            // if no flags but currently registered then unregister
            else if (self._socketMap[socket] != nil) {
                try self.unregister(socket: socket)
            }
            
            // if socket not currently registered and no flags supplied then do nothing
            
        }
        
        /**
         Modify a socket registration. This is equivalent to calling register(socket, flags)
        */
        public func modify(socket: Socket, flags: PollFlags = [.pollIn, .pollOut]) throws {
            // thin wrapper for register
            try self.register(socket: socket, flags: flags)
        }
        
        /**
         Unregister the supplied socket
        */
        public func unregister(socket: Socket) throws {
            let ix = self._socketMap[socket]!
            self._sockets.remove(at: ix)
            // update indices of all other sockets in the socket map
            for (socket, _) in _sockets.suffix(from: ix) {
                let socketIx = self._socketMap[socket]!
                self._socketMap[socket] = socketIx - 1
            }
        }
        
        public func poll(timeout: TimeInterval? = nil) throws -> [Socket: PollFlags] {
            // todo: is there a more swifty way of doing this?
            var intTimeout : Int
            if timeout == nil {
                intTimeout = -1
            }
            else {
                intTimeout = Int(timeout!)
            }
            
            // now poll
            let pollItems = Poller.constructPollItems(sockets: self._sockets)
            let code = zmq_poll(pollItems, Int32(self._sockets.count), intTimeout)
            
            // if code is negative raise the appropriate error
            if code < 0 {
                pollItems.deallocate(capacity: self._sockets.count)
                throw ZeroMQError.last
            }
            // construct return type
            let ret = Poller.constructReturn(sockets: self._sockets, pollItems: pollItems)
            pollItems.deallocate(capacity: self._sockets.count)
            return ret
        }
        
        /*
         Construct return type given sockets
        */
        private static func constructReturn(sockets: [(Socket, PollFlags)],
                                            pollItems: UnsafeMutablePointer<zmq_pollitem_t>)
            -> [Socket: PollFlags]
        {
            // assumes that sockets and poll items are in the same order
            var ret = [Socket: PollFlags]()
            for (ix, (socket, _)) in sockets.enumerated() {
                let pollItem = pollItems[ix]
                let receivedFlags = PollFlags(rawValue: Int32(pollItem.revents))
                
                ret[socket] = receivedFlags
            }
            return ret
        }
        
        /*
         Construct poll items from a supplied list of socket flags
        */
        private static func constructPollItems(sockets: [(Socket, PollFlags)]) -> UnsafeMutablePointer<zmq_pollitem_t> {
            let pollItems = UnsafeMutablePointer<zmq_pollitem_t>.allocate(capacity: sockets.count)
            for (ix, (socket, flags)) in sockets.enumerated() {
                var pollItem = zmq_pollitem_t()
                pollItem.socket = socket.handle
                pollItem.events = Int16(flags.rawValue)
                
                pollItems[ix] = pollItem
            }
            return pollItems
        }
    }

}
