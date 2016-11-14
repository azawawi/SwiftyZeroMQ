//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import XCTest
@testable import SwiftyZeroMQ

class PollerTests: XCTestCase {
    private let endpoint = "tcp://127.0.0.1:5555"

    func testRequestReply() throws {
        let context    = try SwiftyZeroMQ.Context()
        let replier    = try context.socket(.reply)
        try replier.bind(endpoint)
        let requestor  = try context.socket(.request)
        try requestor.connect(endpoint)

        let poller = SwiftyZeroMQ.Poller()

        try poller.register(socket: replier,   flags: [.pollIn, .pollOut])
        try poller.register(socket: requestor, flags: [.pollIn, .pollOut])

        // Initial states: replier should be in none, requestor in pollIn
        var socks = try poller.poll()
        XCTAssertEqual(socks[replier],   SwiftyZeroMQ.PollFlags.none)
        XCTAssertEqual(socks[requestor], SwiftyZeroMQ.PollFlags.pollOut)

        // Requestor should go into none right after sending request
        try requestor.send(string: "msg1", options: .dontWait)
        socks = try poller.poll()
        XCTAssertEqual(socks[requestor], SwiftyZeroMQ.PollFlags.none)

        // After a short wait replier should go into pollIn
        sleep(1)
        socks = try poller.poll()

        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.pollIn)

        // After receive, replier should go into pollOut
        try _ = replier.recv()
        socks = try poller.poll()
        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.pollOut)
    }

    func testPair() throws {
        let context = try SwiftyZeroMQ.Context()
        let s1      = try context.socket(.pair)
        try s1.bind(endpoint)
        let s2      = try context.socket(.pair)
        try s2.connect(endpoint)

        let poller = SwiftyZeroMQ.Poller()

        try poller.register(socket: s1, flags: [.pollIn, .pollOut])
        try poller.register(socket: s2, flags: [.pollIn, .pollOut])

        // Initial states: both should be in pollOut
        var socks = try poller.poll()
        XCTAssertEqual(socks[s1], SwiftyZeroMQ.PollFlags.pollOut)
        XCTAssertEqual(socks[s2], SwiftyZeroMQ.PollFlags.pollOut)

        // Send on both, then both should enter pollIn
        try s1.send(string: "msg1")
        try s2.send(string: "msg2")

        sleep(1)
        socks = try poller.poll()
        XCTAssertEqual(socks[s1], [SwiftyZeroMQ.PollFlags.pollOut, SwiftyZeroMQ.PollFlags.pollIn])
        XCTAssertEqual(socks[s2], [SwiftyZeroMQ.PollFlags.pollOut, SwiftyZeroMQ.PollFlags.pollIn])

        // Now recv both and test they are both back in pollIn
        try _ = s1.recv()
        try _ = s2.recv()
        socks = try poller.poll()
        XCTAssertEqual(socks[s1], SwiftyZeroMQ.PollFlags.pollOut)
        XCTAssertEqual(socks[s2], SwiftyZeroMQ.PollFlags.pollOut)
    }

}
