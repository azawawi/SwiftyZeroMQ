//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import XCTest
@testable import SwiftyZeroMQ

class SocketOptionsTest: XCTestCase {
    private let endpoint = "tcp://127.0.0.1:5550"

    func testSubscribe() throws {
        let context = try SwiftyZeroMQ.Context()
        let pub = try context.socket(.publish)
        let sub1 = try context.socket(.subscribe)
        let sub2 = try context.socket(.subscribe)
        let sub3 = try context.socket(.subscribe)

        try pub.bind(endpoint)
        try sub1.connect(endpoint)
        try sub2.connect(endpoint)
        try sub3.connect(endpoint)

        // Brief wait to let everything hook up
        usleep(1000)

        // sub2 should receive anything
        try sub2.setSubscribe(nil)
        // sub3 should receive only messages starting with "topic"
        try sub3.setSubscribe("topic")

        // Brief wait to let everything hook up
        usleep(250)

        let poller = SwiftyZeroMQ.Poller()
        try poller.register(socket: sub1, flags: .pollIn)
        try poller.register(socket: sub2, flags: .pollIn)
        try poller.register(socket: sub3, flags: .pollIn)

        // Send a message - expect only sub2 to receive
        try pub.send(string: "message")

        // Wait a bit to let the message come through
        usleep(100)

        var socks = try poller.poll(timeout: 1000)
        XCTAssertEqual(socks[sub1], SwiftyZeroMQ.PollFlags.none)
        XCTAssertEqual(socks[sub2], SwiftyZeroMQ.PollFlags.pollIn)
        XCTAssertEqual(socks[sub3], SwiftyZeroMQ.PollFlags.none)

        try _ = sub2.recv(options: .dontWait)

        // Send a message - sub2 and sub3 should receive
        try pub.send(string: "topic: test")

        // Wait a bit to let the message come through
        usleep(100)

        socks = try poller.poll(timeout: 1000)
        XCTAssertEqual(socks[sub1], SwiftyZeroMQ.PollFlags.none)
        XCTAssertEqual(socks[sub2], SwiftyZeroMQ.PollFlags.pollIn)
        XCTAssertEqual(socks[sub3], SwiftyZeroMQ.PollFlags.pollIn)
    }

    func testIntegerOptions() throws {
        let context = try SwiftyZeroMQ.Context()
        let socket = try context.socket(.publish)

        try socket.setAffinity(1)
        XCTAssertEqual(try socket.getAffinity(), 1)

        try socket.setLinger(2)
        XCTAssertEqual(try socket.getLinger(), 2)

        try socket.setRecvHighWaterMark(3)
        XCTAssertEqual(try socket.getRecvHighWaterMark(), 3)

        try socket.setSendHighWaterMark(4)
        XCTAssertEqual(try socket.getSendHighWaterMark(), 4)

        try socket.setMulticastRate(5)
        XCTAssertEqual(try socket.getMulticastRate(), 5)

        try socket.setMulticastRecoveryInterval(6)
        XCTAssertEqual(try socket.getMulticastRecoveryInterval(), 6)

        try socket.setSendBufferSize(7)
        XCTAssertEqual(try socket.getSendBufferSize(), 7)

        try socket.setRecvBufferSize(8)
        XCTAssertEqual(try socket.getRecvBufferSize(), 8)

        try socket.setReconnectInterval(9)
        XCTAssertEqual(try socket.getReconnectInterval(), 9)

        try socket.setMaxReconnectInterval(10)
        XCTAssertEqual(try socket.getMaxReconnectInterval(), 10)

        try socket.setBacklog(11)
        XCTAssertEqual(try socket.getBacklog(), 11)
    }
}
