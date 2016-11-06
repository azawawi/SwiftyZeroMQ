//
//  PollerTests.swift
//  SwiftyZeroMQ
//
//  Created by Jonathan Cockayne on 06/11/2016.
//  Copyright © 2016 azawawi. All rights reserved.
//

import XCTest
@testable import SwiftyZeroMQ

class PollerTests: XCTestCase {
    private let _endpoint = "tcp://127.0.0.1:5555"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestReply() throws {
        let context = try SwiftyZeroMQ.Context()
        let replier = try context.socket(.reply)
        try replier.bind(_endpoint)
        let requestor = try context.socket(.request)
        try requestor.connect(_endpoint)
        
        let poller = SwiftyZeroMQ.Poller()
        
        try poller.register(socket: replier, flags: [.pollIn, .pollOut])
        try poller.register(socket: requestor, flags: [.pollIn, .pollOut])
        
        // initial states: replier should be in none, requestor in pollIn
        var socks = try poller.poll()
        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.none)
        XCTAssertEqual(socks[requestor], SwiftyZeroMQ.PollFlags.pollOut)
        
        // requestor should go into none right after sending request
        try requestor.send(string: "msg1", options: .dontWait)
        socks = try poller.poll()
        XCTAssertEqual(socks[requestor], SwiftyZeroMQ.PollFlags.none)
        
        // after a short wait replier should go into pollIn
        sleep(1)
        socks = try poller.poll()
        
        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.pollIn)
        
        // after receive, replier should go into pollOut
        try _ = replier.recv()
        socks = try poller.poll()
        XCTAssertEqual(socks[replier], SwiftyZeroMQ.PollFlags.pollOut)
    }
    
    func testPair() throws {
        let context = try SwiftyZeroMQ.Context()
        let s1 = try context.socket(.pair)
        try s1.bind(_endpoint)
        let s2 = try context.socket(.pair)
        try s2.connect(_endpoint)
        
        let poller = SwiftyZeroMQ.Poller()
        
        try poller.register(socket: s1, flags: [.pollIn, .pollOut])
        try poller.register(socket: s2, flags: [.pollIn, .pollOut])
        
        // initial states: both should be in pollOut
        var socks = try poller.poll()
        XCTAssertEqual(socks[s1], SwiftyZeroMQ.PollFlags.pollOut)
        XCTAssertEqual(socks[s2], SwiftyZeroMQ.PollFlags.pollOut)
        
        // send on both, then both should enter pollIn
        try s1.send(string: "msg1")
        try s2.send(string: "msg2")
        
        sleep(1)
        socks = try poller.poll()
        XCTAssertEqual(socks[s1], [SwiftyZeroMQ.PollFlags.pollOut, SwiftyZeroMQ.PollFlags.pollIn])
        XCTAssertEqual(socks[s2], [SwiftyZeroMQ.PollFlags.pollOut, SwiftyZeroMQ.PollFlags.pollIn])
        
        // now recv both and test they are both back in pollIn
        try _ = s1.recv()
        try _ = s2.recv()
        socks = try poller.poll()
        XCTAssertEqual(socks[s1], SwiftyZeroMQ.PollFlags.pollOut)
        XCTAssertEqual(socks[s2], SwiftyZeroMQ.PollFlags.pollOut)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
