//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

extension SwiftyZeroMQ {

    /**
        This represents a ZeroMQ context
     */
    public class Context: Hashable {
        /**
            This is the low-level context pointer handle. Please be extra
            careful while using this one otherwise crashes and memory leaks may
            occur.
         */
        public var handle : UnsafeMutableRawPointer?

        /**
            This is used internally to manage context handle cleanup in
            deinitialization
         */
        private var cleanupNeeded : Bool

        /**
            Create a new ZeroMQ context

            - throws: ZeroMQError
         */
        public init() throws {
            let contextHandle = zmq_ctx_new()
            if contextHandle == nil {
                throw ZeroMQError.last
            }

            handle = contextHandle
            cleanupNeeded = true
        }

        /**
            Called automatically by garbage collector to terminate context
         */
        deinit {
            guard cleanupNeeded else {
                // No need to cleanup, user has already done that
                return
            }

            do {
                try terminate()
            } catch {
                print(error)
            }
        }

        /**
            Shutdown the current context without terminating the current context
         */
        public func shutdown() throws {
            guard handle != nil else {
                return
            }

            let result = zmq_ctx_shutdown(handle)
            if result == -1 {
                throw ZeroMQError.last
            } else {
                handle = nil
                cleanupNeeded = false
            }
        }

        /**
            Terminate the current context and block until all open sockets
            are closed or their linger period has expired
         */
        public func terminate() throws {
            guard handle != nil else {
                // No need to terminate
                return
            }

            let result = zmq_ctx_term(handle)
            if result == -1 {
                throw ZeroMQError.last
            } else {
                handle = nil
            }
        }

        /**
            An alias for `terminate`
         */
        public func close() throws {
            try terminate()
        }

        /**
            Returns a ZMQ socket with the type provided
            - parameters:
                - type: socket type of type SocketType
            - returns: a ZeroMQ socket with the type provided
         */
        public func socket(_ type : SwiftyZeroMQ.SocketType) throws -> Socket {
            return try Socket(context: self, type: type)
        }

        /**
            Returns the current context option value (private)

            - parameters:
                - name: option name
            - returns: the option value
         */
        private func getOption(_ name : Int32) throws -> Int32 {
            let result = zmq_ctx_get(handle, name)
            if result == -1 {
                throw ZeroMQError.last
            }

            return result
        }

        /**
            Sets the current context option value (private)

            - parameters:
                - name: the option name
                - value: the option value to be set
         */
        private func setOption(_ name: Int32, _ value: Int32) throws {
            let result = zmq_ctx_set(handle, name, value)
            if result == -1 {
                throw ZeroMQError.last
            }
        }

        /**
            Returns whether the `terminate` method call will block forever or
            not. Default option value is true.

            By default the context will block, forever, on a `.terminate` call.
            The assumption behind this behavior is that abrupt termination will
            cause message loss. Most real applications use some form of
            handshaking to ensure applications receive termination messages, and
            then terminate the context with `socket.setLinger(0)` on all
            sockets. This setting is an easier way to get the same result. When
            it is set to false, all new sockets are given a linger timeout of
            zero. **You must still close all sockets before calling terminate.**
         */
        public func isBlocky() throws -> Bool {
            return try getOption(ZMQ_BLOCKY) == 1
        }

        /**
            Sets whether the `terminate` method call will block forever or not.
            Default option value is true.

            By default the context will block, forever, on a `.terminate` call.
            The assumption behind this behavior is that abrupt termination will
            cause message loss. Most real applications use some form of
            handshaking to ensure applications receive termination messages, and
            then terminate the context with `socket.setLinger(0)` on all
            sockets. This setting is an easier way to get the same result. When
            it is set to false, all new sockets are given a linger timeout of
            zero. **You must still close all sockets before calling terminate.**
         */
        public func setBlocky(_ enabled : Bool = true) throws {
          try setOption(ZMQ_BLOCKY, enabled ? 1 : 0)
        }

        /**
            Returns the number of I/O threads for the current context

            Default value is 1 (read and write)

            returns: The number of I/O threads for the current context
         */
        public func getIOThreads() throws -> Int {
            return try Int(getOption(ZMQ_IO_THREADS))
        }

        /**
            Sets the number of I/O threads for the current context

            Default value is 1 (read and write)
         */
        public func setIOThreads(_ value : Int = 1) throws {
            try setOption(ZMQ_IO_THREADS, Int32(value))
        }

        /**
            Sets the scheduling policy for I/O threads for the current context

            Default value is -1 (write only)
         */
        public func setThreadSchedulingPolicy(_ value : Int = -1) throws {
            try setOption(ZMQ_THREAD_SCHED_POLICY, Int32(value))
        }

        /**
            Sets the scheduling priority for I/O threads for the current context

            Default value is -1 (write only)
         */
        public func setThreadPriority(_ value : Int = -1) throws {
            try setOption(ZMQ_THREAD_PRIORITY, Int32(value))
        }

        /**
            Returns the maximum allowed size of a message sent in the current
            context. Default value is Int32.max (i.e. 2147483647).

            Default value is Int32.max (i.e. 2147483647)
         */
        public func getMaxMessageSize() throws -> Int {
           return try Int(getOption(ZMQ_MAX_MSGSZ))
        }

         /**
             Sets the maximum allowed size of a message sent in the current
             context. Default value is Int32.max (i.e. 2147483647).
          */
        public func setMaxMessageSize(_ size : Int = Int(Int32.max)) throws {
            try setOption(ZMQ_MAX_MSGSZ, Int32(size))
        }

        /**
            Returns the maximum number of sockets associated with the current
            context

            Default value is 1024 (read/write)
         */
        public func getMaxSockets() throws -> Int {
            return try Int(getOption(ZMQ_MAX_SOCKETS))
        }

        /**
            Sets the maximum number of sockets associated with the current
            context

            Default value is 1024 (read/write)
         */
        public func setMaxSockets(_ value : Int = 1024) throws {
            try setOption(ZMQ_MAX_SOCKETS, Int32(value))
        }

        /**
            Returns whether the IPV6 is enabled or not for the current context

            Default value is false (read/write)
         */
        public func isIPV6Enabled() throws -> Bool {
            return try getOption(ZMQ_IPV6) == 1
        }

        /**
            Sets whether the IPV6 is enabled or not for the current context

            Default value is false (read/write)
         */
        public func setIPV6Enabled(_ enabled : Bool = false) throws {
            try setOption(ZMQ_IPV6, enabled ? 1 : 0)
        }

        /**
            The maximum socket limit associated with the current context

            Default value: (read only)
         */
        public func getSocketLimit() throws -> Int {
            return try Int(getOption(ZMQ_SOCKET_LIMIT))
        }

        /**
            Hashable implementation
        */
        public var hashValue: Int {
            if let hashValue = handle?.hashValue {
                return hashValue
            }
            else {
                return 0 // todo: not clear what this corresponds to...
            }
        }

        /**
            Equatable implementation (inherited from Hashable)
        */
        public static func ==(lhs: Context, rhs: Context) -> Bool {
            return lhs.handle == rhs.handle
        }

    }

}
