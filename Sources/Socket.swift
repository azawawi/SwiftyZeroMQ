//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import Foundation

extension SwiftyZeroMQ {

    /**
        This represents a ZeroMQ socket that is associated with a context
     */
    public class Socket : Hashable {
        /**
            This is the low-level socket pointer handle. Please be extra careful
            while using this one otherwise crashes and memory leaks may occur.
         */
        public var handle : UnsafeMutableRawPointer?

        /**
            This is used internally to manage socket handle cleanup in
            deinitialization
         */
        private var cleanupNeeded : Bool

        /**
            Creates a new type of socket associated with the provided context
         */
        public init(context: Context, type : SocketType) throws {
            // Create socket
            let p : UnsafeMutableRawPointer? = zmq_socket(context.handle,
                type.rawValue)
            guard p != nil else {
                throw ZeroMQError.last
            }

            // Now we can assign socket handle safely
            handle = p!
            cleanupNeeded = true
        }

        /**
            Called by the garbage collector automatically to close the socket
         */
        deinit {
            guard cleanupNeeded else {
                // No need to cleanup, user has already done that
                return
            }

            do {
                try close()
            } catch {
                print(error)
            }
        }

        /**
            Create an outgoing connection on the current socket
         */
        public func connect(_ endpoint : String) throws {
            let result = zmq_connect(handle, endpoint)
            if result == -1 {
                throw ZeroMQError.last
            }
        }

        /**
            Closes the current socket
         */
        public func close() throws {
            let result = zmq_close(handle)
            if result == -1 {
                throw ZeroMQError.last
            } else {
                cleanupNeeded = false
            }
        }

        /**
            Accept incoming connections on the current socket
         */
        public func bind(_ endpoint: String) throws {
            let result = zmq_bind(handle, endpoint)
            if result == -1 {
                throw ZeroMQError.last
            }
        }

        /**
            Stop accepting connections on the current socket
         */
        public func unbind(_ endpoint: String) throws {
            let result = zmq_unbind(handle, endpoint)
            if result == -1 {
                throw ZeroMQError.last
            }
        }

        /**
            Send a message part via the current socket
         */
        public func send(
            string  : String,
            options : SocketSendRecvOption = .none) throws
        {
            let result = zmq_send(handle, string, string.characters.count,
                options.rawValue)
            if result == -1 {
                throw ZeroMQError.last
            }
        }

        /**
            Receive a message part from the current socket
         */
        public func recv(
            bufferLength : Int = 256,
            options      : SocketSendRecvOption = .none
        ) throws -> String? {
            // Validate allowed options
            guard options.isValidRecvOption() else {
                throw ZeroMQError.invalidOption
            }

            // Read n bytes from socket into buffer
            let buffer = UnsafeMutablePointer<CChar>.allocate(
                capacity: bufferLength)
            let bufferSize = zmq_recv(handle, buffer, bufferLength,
                options.rawValue)
            if bufferSize == -1 {
                throw ZeroMQError.last
            }

            // Limit string buffer to actual buffer size
            let data = Data(bytes: buffer, count: Int(bufferSize))

            // Return read UTF8 string
            return String(data: data, encoding: String.Encoding.utf8)
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
        public static func ==(lhs: Socket, rhs: Socket) -> Bool {
            return lhs.handle == rhs.handle
        }
    }

}
