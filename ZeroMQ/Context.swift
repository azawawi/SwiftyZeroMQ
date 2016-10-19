//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import CZeroMQ

extension ZeroMQ {

    public class Context {
        public var handle : UnsafeMutableRawPointer?

        /*
            Create a new ZeroMQ context
         */
        public init() throws {
            let contextHandle = zmq_ctx_new()
            if contextHandle == nil {
                throw ZeroMQError.last
            }

            handle = contextHandle
        }

        /*
            Called automatically by garbage collector to terminate context
         */
        deinit {
            do {
                try terminate()
            } catch {
                print(error)
            }
        }

        /*
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
            }
        }

        /*
            Terminate the current context and block until all open sockets
            are closed or their linger period has expired
         */
        public func terminate() throws {
            guard handle != nil else {
                return
            }

            let result = zmq_ctx_term(handle)
            if result == -1 {
                throw ZeroMQError.last
            } else {
                handle = nil
            }
        }

        /*
            Returns a ZMQ socket with the type provided
         */
        public func socket(_ type : ZeroMQ.SocketType) throws -> Socket {
            return try Socket(context: self, type: type)
        }

        /*
            Returns the current context option value (private)
         */
        private func getOption(_ name : Int32) throws -> Int32 {
            let result = zmq_ctx_get(handle, name)
            if result == -1 {
                throw ZeroMQError.last
            }

            return result
        }

        /*
            Sets the current context option value (private)
         */
        private func setOption(_ name: Int32, _ value: Int32) throws {
            let result = zmq_ctx_set(handle, name, value)
            if result == -1 {
                throw ZeroMQError.last
            }
        }

        /*
            Returns the number of I/O threads for the current context

            Default value is 1 (read and write)
         */
        public func getIOThreads() throws -> Int {
            return try Int(getOption(ZMQ_IO_THREADS))
        }

        /*
            Sets the number of I/O threads for the current context

            Default value is 1 (read and write)
         */
        public func setIOThreads(_ value : Int = 1) throws {
            try setOption(ZMQ_IO_THREADS, Int32(value))
        }

        /*
            Sets the scheduling policy for I/O threads for the current context

            Default value is -1 (write only)
         */
        public func setThreadSchedulingPolicy(_ value : Int = -1) throws {
            try setOption(ZMQ_THREAD_SCHED_POLICY, Int32(value))
        }

        /*
            Sets the scheduling priority for I/O threads for the current context

            Default value is -1 (write only)
         */
        public func setThreadPriority(_ value : Int = -1) throws {
            try setOption(ZMQ_THREAD_PRIORITY, Int32(value))
        }

        /*
            Returns the maximum number of sockets associated with the current
            context

            Default value is 1024 (read/write)
         */
        public func getMaxSockets() throws -> Int {
            return try Int(getOption(ZMQ_MAX_SOCKETS))
        }

        /*
            Sets the maximum number of sockets associated with the current
            context

            Default value is 1024 (read/write)
         */
        public func setMaxSockets(_ value : Int = 1024) throws {
            try setOption(ZMQ_MAX_SOCKETS, Int32(value))
        }

        /*
            Returns whether the IPV6 is enabled or not for the current context

            Default value is false (read/write)
         */
        public func isIPV6Enabled() throws -> Bool {
            return try getOption(ZMQ_IPV6) == 1
        }

        /*
            Sets whether the IPV6 is enabled or not for the current context

            Default value is false (read/write)
         */
        public func setIPV6Enabled(_ enabled : Bool = false) throws {
            try setOption(ZMQ_IPV6, enabled ? 1 : 0)
        }

        /*
            The maximum socket limit associated with the current context

            Default value: (read only)
         */
        public func getSocketLimit() throws -> Int {
            return try Int(getOption(ZMQ_SOCKET_LIMIT))
        }

    }

}
