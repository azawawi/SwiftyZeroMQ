//
//  SocketOptions.swift
//  SwiftyZeroMQ
//
//  Created by Jonathan Cockayne on 06/11/2016.
//  Copyright © 2016 azawawi. All rights reserved.
//

import UIKit
extension SwiftyZeroMQ.Socket {
    
    // MARK: High level setters
    
    /**
     Establish a new message filter on this socket. Newly created ZMQ_SUB sockets filter out all incoming messages, therefore you should call this option to establish an initial message filter. This only applies to SwiftyZeroMQ.SocketType.subscribe sockets.
     
     Setting value to nil subscribes to all incoming messages. A non-empty value subscribes to all messages beginning with the specified prefix. Multiple filters may be attached to a single socket, in which case a message is accepted if it matches at least one filter.
     */
    public func setSubscription(_ value: String?) throws {
        try self.setStringOption(ZMQ_SUBSCRIBE, value)
    }
    
    /**
     Set the I/O thread affinity for newly created connections on this socket.
     */
    public func setAffinity(_ value: UInt64) throws {
        try self.setValueOption(ZMQ_AFFINITY, value)
    }
    
    /**
     Set the linger period for this socket. The linger period determines how long pending messages which have yet to be sent to a peer linger in memory after a socket is closed.
     */
    public func setLinger(_ value: Int32) throws {
        try self.setValueOption(ZMQ_LINGER, value)
    }
    
    /**
     Set the receive high water mark for this socket. The high water mark is a hard limit on the maximum number of outstanding messages ZMQ shall queue in memory for any single peer that the specified socket is communicating with.
     */
    public func setRecvHighWaterMark(_ value: UInt32) throws {
        try self.setValueOption(ZMQ_RCVHWM, value)
    }
    
    /**
     Set the send high water mark for this socket. The high water mark is a hard limit on the maximum number of outstanding messages ZMQ shall queue in memory for any single peer that the specified socket is communicating with.
     */
    public func setSendHighWaterMark(_ value: UInt32) throws {
        try self.setValueOption(ZMQ_SNDHWM, value)
    }
    
    /**
     Set the maximum send or receive data rate for multicast transports.
     */
    public func setMulticastRate(_ value: Int32) throws {
        try self.setValueOption(ZMQ_RATE, value)
    }
    
    /**
     Set the recovery interval for multicast transports using the specified socket. The recovery interval determines the maximum time in seconds that a receiver can be absent from a multicast group before unrecoverable data loss will occur.
     */
    public func setMulticastRecoveryInterval(_ value: Int32) throws {
        try self.setValueOption(ZMQ_RECOVERY_IVL, value)
    }
    
    /**
     Set the underlying kernel transmit buffer size for the socket to the specified size in bytes. A value of zero means leave the OS default unchanged. For details please refer to your operating system documentation for the SO_SNDBUF socket option.
     */
    public func setSendBufferSize(_ value: Int32) throws {
        try self.setValueOption(ZMQ_SNDBUF, value)
    }
    
    /**
     Set the underlying kernel receive buffer size for the socket to the specified size in bytes. A value of zero means leave the OS default unchanged. For details refer to your operating system documentation for the SO_RCVBUF socket option.
     */
    public func setRecvBufferSize(_ value: Int32) throws {
        try self.setValueOption(ZMQ_RCVBUF, value)
    }
    
    /**
     Set the initial reconnection interval for the specified socket. The reconnection interval is the period ZMQ shall wait between attempts to reconnect disconnected peers when using connection-oriented transports.
     
     */
    public func setReconnectInterval(_ value: Int32) throws {
        try self.setValueOption(ZMQ_RECONNECT_IVL, value)
    }
    
    /**
     Set the maximum reconnection interval for the specified socket. This is the maximum period ZMQ shall wait between attempts to reconnect.
     */
    public func setMaxReconnectInterval(_ value: Int32) throws {
        try self.setValueOption(ZMQ_RECONNECT_IVL_MAX, value)
    }
    
    /**
     Set the maximum length of the queue of outstanding peer connections for the specified socket; this only applies to connection-oriented transports.
     */
    public func setBacklog(_ value: Int32) throws {
        try self.setValueOption(ZMQ_BACKLOG, value)
    }
    
    // MARK: High level getters
    
    public func getAffinity() throws -> UInt64  {
        return try self.getValueOption(ZMQ_AFFINITY)
    }
    
    public func getLinger() throws -> Int32 {
        return try self.getValueOption(ZMQ_LINGER)
    }
    
    public func getRecvHighWaterMark() throws -> UInt32 {
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
    
    // MARK: Raw Setters
    
    // TODO: Move this to helper functions
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
     Generically set an option which is just a single value, such as an Int, Int64 or UInt64
     */
    private func setValueOption<T>(_ name: Int32, _ value: T) throws {
        let pointer = SwiftyZeroMQ.Socket.pointerTo(value)
        try self.setOption(name, pointer, MemoryLayout<T>.size)
    }
    
    /**
     Raw interface to set a socket option in ZMQ
     */
    private func setOption(_ name: Int32, _ value: UnsafeRawPointer, _ valueLength: Int) throws {
        if zmq_setsockopt(self.handle, name, value, valueLength) < 0 {
            throw SwiftyZeroMQ.ZeroMQError.last
        }
    }
    
    // MARK: Raw Getters
    /**
     Generically get an option which is just a single value, such as an Int, Int64 or UInt64
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
