//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import XCTest
@testable import SwiftyZeroMQ

class PollerTests: XCTestCase {
    private let endpoint = "tcp://127.0.0.1:5551"

    func testRequestReply() throws {
        // Context
        let context    = try SwiftyZeroMQ.Context()

        // Replier socket
        let replier    = try context.socket(.reply)
        try replier.bind(endpoint)

        // Requester socket
        let requestor  = try context.socket(.request)
        try requestor.connect(endpoint)

        // Wait a bit to allow the sockets to connect
        usleep(250)

        // Register requester and replier sockets in a new poller object
        let poller = SwiftyZeroMQ.Poller()
        try poller.register(socket: replier,   flags: [.pollIn, .pollOut])
        try poller.register(socket: requestor, flags: [.pollIn, .pollOut])

        // Replier should initially be in .none and requestor in .pollIn
        var socks = try poller.poll()
        XCTAssertEqual(socks[replier],   SwiftyZeroMQ.PollFlags.none)
        XCTAssertEqual(socks[requestor], SwiftyZeroMQ.PollFlags.pollOut)

        // Requestor should go into .none right after sending request
        try requestor.send(string: "msg1", options: .dontWait)
        socks = try poller.poll()
        XCTAssertEqual(socks[requestor], SwiftyZeroMQ.PollFlags.none)

        // After a short wait replier should go into .pollIn
        usleep(500)
        socks = try poller.poll()

        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.pollIn)

        // After receive, replier should go into .pollOut
        try _ = replier.recv()
        socks = try poller.poll()
        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.pollOut)

        // Cleanup
        try poller.unregister(socket: replier)
        try poller.unregister(socket: requestor)
    }

    func testPair() throws {
        // Context
        let context = try SwiftyZeroMQ.Context()

        // Create two pair sockets (bind, connect)
        let s1      = try context.socket(.pair)
        try s1.bind(endpoint)
        let s2      = try context.socket(.pair)
        try s2.connect(endpoint)

        // Wait a bit to allow the sockets to connect
        usleep(250)

        // Register pair sockets in a new poller object
        let poller  = SwiftyZeroMQ.Poller()
        try poller.register(socket: s1, flags: [.pollIn, .pollOut])
        try poller.register(socket: s2, flags: [.pollIn, .pollOut])

        // Initially both should be in .pollOut
        var socks = try poller.poll()
        XCTAssertEqual(socks[s1], SwiftyZeroMQ.PollFlags.pollOut)
        XCTAssertEqual(socks[s2], SwiftyZeroMQ.PollFlags.pollOut)

        // Send on both, then both should enter pollIn
        try s1.send(string: "msg1")
        try s2.send(string: "msg2")

        // After a wait, both should be [.pollout, .pollIn]
        usleep(500)
        socks = try poller.poll()
        XCTAssertEqual(socks[s1], [SwiftyZeroMQ.PollFlags.pollOut, SwiftyZeroMQ.PollFlags.pollIn])
        XCTAssertEqual(socks[s2], [SwiftyZeroMQ.PollFlags.pollOut, SwiftyZeroMQ.PollFlags.pollIn])

        // Now read from both and test they are both back in .pollOut
        try _ = s1.recv()
        try _ = s2.recv()
        socks = try poller.poll()
        XCTAssertEqual(socks[s1], SwiftyZeroMQ.PollFlags.pollOut)
        XCTAssertEqual(socks[s2], SwiftyZeroMQ.PollFlags.pollOut)

        // Cleanup
        try poller.unregister(socket: s1)
        try poller.unregister(socket: s2)
    }

}
