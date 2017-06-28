//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
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
            try send(data: string.data(using: .utf8)!, options: options)
        }
        
        public func send(
            data  : Data,
            options : SocketSendRecvOption = .none) throws
        {
            let result = zmq_send(handle, (data as NSData).bytes, data.count,
                                  options.rawValue)
            if result == -1 {
                throw ZeroMQError.last
            }
        }
        
        public func sendMultipart(parts: Array<Data>) throws {
            for data in parts.dropLast() {
                try send(data: data, options: .sendMore)
            }
            try send(data: parts.last!, options: .none)
        }
        
        public func recvMultipart() throws -> Array<Data> {
            var parts: Array<Data> = []
            var msg = zmq_msg_t.init()
            var result: Int32
            let flags: SocketSendRecvOption = .none
            repeat {
                result = zmq_msg_init(&msg)
                if (result == -1) { throw ZeroMQError.last }
                
                defer {
                    // Clean up message on scope exit
                    zmq_msg_close(&msg)
                }
                
                result = zmq_recvmsg(handle, &msg, flags.rawValue)
                if (result == -1) { throw ZeroMQError.last }
                
                let length = zmq_msg_size(&msg);
                parts.append(NSData(bytes:zmq_msg_data(&msg), length:length) as Data)
                
            } while(zmq_msg_more(&msg) > 0)
            // TODO free msg?
            return parts
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

            defer {
                // Clean up allocated buffer on scope exit
                buffer.deallocate(capacity: bufferLength)
            }

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

        /**
           Establish a new message filter on this socket. Newly created ZMQ_SUB
           sockets filter out all incoming messages, therefore you should call
           this option to establish an initial message filter. This only applies
           to SwiftyZeroMQ.SocketType.subscribe sockets.

           Setting value to nil subscribes to all incoming messages. A non-empty
           value subscribes to all messages beginning with the specified prefix.
           Multiple filters may be attached to a single socket, in which case a
           message is accepted if it matches at least one filter.
         */
        public func setSubscribe(_ value: String?) throws {
            try self.setStringSocketOption(ZMQ_SUBSCRIBE, value)
//            try self.setStringOption(ZMQ_SUBSCRIBE, value)
        }

        /**
           Set the I/O thread affinity for newly created connections on this
           socket.
         */
        public func setAffinity(_ value: UInt64) throws {
              try self.setUnsignedIntegerSocketOption(ZMQ_AFFINITY, value)        }

        /**
          Set the linger period for this socket. The linger period determines
          how long pending messages which have yet to be sent to a peer linger
          in memory after a socket is closed.
         */
        public func setLinger(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_LINGER, value)
        }

        /**
          Set the receive high water mark for this socket. The high water mark
          is a hard limit on the maximum number of outstanding messages ZMQ
          shall queue in memory for any single peer that the specified socket is
          communicating with.
         */
        public func setRecvHighWaterMark(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_RCVHWM, value)
        }

        /**
           Set the send high water mark for this socket. The high water mark is
           a hard limit on the maximum number of outstanding messages ZMQ shall
           queue in memory for any single peer that the specified socket is
           communicating with.
         */
        public func setSendHighWaterMark(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_SNDHWM, value)
        }

        /**
          Set the maximum send or receive data rate for multicast transports.
         */
        public func setMulticastRate(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_RATE, value)
        }

        /**
           Set the recovery interval for multicast transports using the
           specified socket. The recovery interval determines the maximum time
           in seconds that a receiver can be absent from a multicast group
           before unrecoverable data loss will occur.
         */
        public func setMulticastRecoveryInterval(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_RECOVERY_IVL, value)
        }

        /**
           Set the underlying kernel transmit buffer size for the socket to the
           specified size in bytes. A value of zero means leave the OS default
           unchanged. For details please refer to your operating system
           documentation for the SO_SNDBUF socket option.
         */
        public func setSendBufferSize(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_SNDBUF, value)
        }

        /**
           Set the underlying kernel receive buffer size for the socket to the
           specified size in bytes. A value of zero means leave the OS default
           unchanged. For details refer to your operating system documentation
           for the SO_RCVBUF socket option.
         */
        public func setRecvBufferSize(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_RCVBUF, value)
        }

        /**
           Set the initial reconnection interval for the specified socket. The
           reconnection interval is the period ZMQ shall wait between attempts
           to reconnect disconnected peers when using connection-oriented
           transports.
         */
        public func setReconnectInterval(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_RECONNECT_IVL, value)
        }

        /**
           Set the maximum reconnection interval for the specified socket. This
           is the maximum period ZMQ shall wait between attempts to reconnect.
         */
        public func setMaxReconnectInterval(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_RECONNECT_IVL_MAX, value)
        }
      
      /// Returns a public/private key tuple using zmq_curve_keypair
      ///
      /// - Returns: tuple with public/private keys of 40 bytes length
      /// - Throws: ZMQError
      public func curveKeyPair() throws -> (publicKey: String, secretKey: String) {
        //create public and secret keys for passing to the keypair generation function
        var publicKey = [Int8](repeating: 0, count: 40)
        var secretKey = [Int8](repeating: 0, count: 40)
        //generate the key
        let response = zmq_curve_keypair(&publicKey, &secretKey)
        //throw error if something went wrong
        if response == -1 {
          throw ZeroMQError.last
        }
        //    return a tuple of public and secret keys as strings
        return (String(validatingUTF8: publicKey)!, String(validatingUTF8: secretKey)!)
      }
      
      /// Prepares a socket to use curve security
      ///
      /// - Parameters:
      ///   - serverPublicKey: Public key from the server
      ///   - clientPublicKey: Public key for the client socket
      ///   - clientSecretKey: Private key for this socket
      /// - Throws:
      public func setupCurveSecurityOnClientWithServerPublicKey(_ serverPublicKey: String, clientPublicKey: String, clientSecretKey: String) throws {
        do {

          
          //set the client public and private keys, and the server public key
          try setStringSocketOption(ZMQ_CURVE_PUBLICKEY, clientPublicKey)
          try setStringSocketOption(ZMQ_CURVE_SECRETKEY, clientSecretKey)
          try setStringSocketOption(ZMQ_CURVE_SERVERKEY, serverPublicKey)
        } catch {
          print("Error setting up client keys: \(error)")
        }
      }
      
      /// Set up curve security on a server socket
      ///
      /// - Parameters:
      ///   - serverSecretKey: Secret key of the server
      ///   - serverPublicKey: Public key of the server
      /// - Throws:
      public func setupCurveSecurityOnServerWithServerSecretKey(_ serverSecretKey: String, serverPublicKey: String) throws {
        do {
          //tell our socket that we're a server
          try setIntegerSocketOption(ZMQ_CURVE_SERVER, 1)
          
          //set our secret key
          try setStringSocketOption(ZMQ_CURVE_SECRETKEY, serverSecretKey)
          
          try setStringSocketOption(ZMQ_CURVE_PUBLICKEY, serverPublicKey)
          
        } catch {
          print("Error setting up server socket: \(error)")
        }
        
        
        
      }

        /**
           Set the maximum length of the queue of outstanding peer connections
           for the specified socket; this only applies to connection-oriented
           transports.
         */
        public func setBacklog(_ value: Int32) throws {
            try self.setIntegerSocketOption(ZMQ_BACKLOG, value)
        }

        public func getAffinity() throws -> UInt64  {
            return try self.getValueOption(ZMQ_AFFINITY)
        }

        public func getLinger() throws -> Int32 {
            return try self.getValueOption(ZMQ_LINGER)
        }

        public func getRecvHighWaterMark() throws -> Int32 {
            return try self.getValueOption(ZMQ_RCVHWM)
        }

        public func getSendHighWaterMark() throws -> UInt32 {
            return try self.getValueOption(ZMQ_SNDHWM)
        }

        public func getMulticastRate() throws -> Int32 {
            return try self.getValueOption(ZMQ_RATE)
        }

        public func getMulticastRecoveryInterval() throws -> Int32 {
            return try self.getValueOption(ZMQ_RECOVERY_IVL)
        }

        public func getSendBufferSize() throws -> UInt32 {
            return try self.getValueOption(ZMQ_SNDBUF)
        }

        public func getRecvBufferSize() throws -> UInt32 {
            return try self.getValueOption(ZMQ_RCVBUF)
        }

        public func getReconnectInterval() throws -> UInt32 {
            return try self.getValueOption(ZMQ_RECONNECT_IVL)
        }

        public func getMaxReconnectInterval() throws -> UInt32 {
            return try self.getValueOption(ZMQ_RECONNECT_IVL_MAX)
        }

        public func getBacklog() throws -> UInt32 {
            return try self.getValueOption(ZMQ_BACKLOG)
        }

        // TODO Move this to helper functions
        private static func pointerTo<T>(_ value: T) -> UnsafeRawPointer {
            var mutableValue = value
            let data = Data(bytes: &mutableValue, count: MemoryLayout<T>.size)
            return data.withUnsafeBytes { (u8ptr: UnsafePointer<UInt8>) in
                return UnsafeRawPointer(u8ptr)
            }
        }

        /**
          Interface to set an option which takes a Swift String.
         */
        private func setStringOption(_ name: Int32, _ value: String?) throws {
            let optValLen = (value != nil)
                ? value!.characters.count
                : 0
            let optval = (value != nil)
                ? UnsafeRawPointer(value!)
                : UnsafeRawPointer([UInt8]())

            try self.setOption(name, optval, optValLen)
        }

        /**
          Generically set an option which is just a single value, such as an
          Int, Int64 or UInt64
         */
        private func setValueOption<T>(_ name: Int32, _ value: T) throws {
            let pointer = SwiftyZeroMQ.Socket.pointerTo(value)
            try self.setOption(name, pointer, MemoryLayout<T>.size)
        }
      
      func setIntegerSocketOption(_ option: Int32, _ value: Int32) throws {
        var value = value
        try setOption(option, &value, MemoryLayout<Int32>.size)
      }
      
      func setUnsignedIntegerSocketOption(_ option: Int32, _ value: UInt64) throws {
        var value = value
        try setOption(option, &value, MemoryLayout<UInt64>.size)
      }

      
      func setStringSocketOption(_ option: Int32, _ value: String?) throws {
        if let value = value {
          try value.withCString { v in
//            print("Setting option \(v) length \(value.utf8.count)")
            try setOption(option, v, value.utf8.count)
          }
        } else {
          try setOption(option, nil, 0)
        }
      }
      
        /**
           Raw interface to set a socket option in ZMQ
         */
        private func setOption(
          _ name        : Int32,
          _ value       : UnsafeRawPointer?,
          _ valueLength : Int) throws
        {
            if zmq_setsockopt(self.handle, name, value, valueLength) < 0 {
                throw SwiftyZeroMQ.ZeroMQError.last
            }
        }

        /**
           Generically get an option which is just a single value, such as an
           Int, Int64 or UInt64
         */
        private func getValueOption<T>(_ name: Int32) throws -> T {

            let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
            defer {
                pointer.deallocate(capacity: 1)
            }

            var sz = MemoryLayout<T>.size
            let optLen = UnsafeMutablePointer(&sz)

            if zmq_getsockopt(self.handle, name, pointer, optLen) < 0 {
                throw SwiftyZeroMQ.ZeroMQError.last
            }
            return pointer.move()
        }

    }

}
