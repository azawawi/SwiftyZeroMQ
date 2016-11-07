//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import XCTest
@testable import SwiftyZeroMQ

class ZeroMQTests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of
        // each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation
        // of each test method in the class.

        super.tearDown()
    }

    func testVersion() {
        let (major, minor, patch, versionString) = SwiftyZeroMQ.version
        XCTAssertTrue(major == 4, "Major version is 4")
        XCTAssertTrue(minor == 1, "Minor version is 1")
        XCTAssertTrue(patch == 6, "Patch version is 6")
        XCTAssertTrue(versionString == "\(major).\(minor).\(patch)")

        let frameworkVersion = SwiftyZeroMQ.frameworkVersion
        XCTAssertTrue(frameworkVersion != nil)
        let regex = "^\\d+\\.\\d+\\.\\d+$"
        XCTAssertTrue(frameworkVersion?.range(of: regex, options : .regularExpression) != nil)
    }

    func testHas() {
        let _ = SwiftyZeroMQ.has(.ipc)
        XCTAssertTrue(true, ".ipc works")

        let _ = SwiftyZeroMQ.has(.pgm)
        XCTAssertTrue(true, ".pgm works")

        let _ = SwiftyZeroMQ.has(.tipc)
        XCTAssertTrue(true, ".tipc works")

        let _ = SwiftyZeroMQ.has(.norm)
        XCTAssertTrue(true, ".norm works")

        let _ = SwiftyZeroMQ.has(.curve)
        XCTAssertTrue(true, ".curve works")

        let _ = SwiftyZeroMQ.has(.gssapi)
        XCTAssertTrue(true, ".gssapi works")
    }

    func testContext() {
        do {
            let context = try SwiftyZeroMQ.Context()
            XCTAssertTrue(true, "Context created")
            XCTAssertTrue(context.handle != nil, "socket.handle is not nil")

            // ioThreads
            XCTAssertTrue( try context.getIOThreads() == 1,
                "Default value for ioThreads is 1" )
            let newIoThread = 2
            try context.setIOThreads(newIoThread)
            XCTAssertTrue( try context.getIOThreads() == newIoThread,
                           "ioThreads setter works" )

            // maxSockets and socketLimit
            let socketLimit = try context.getSocketLimit()
            XCTAssertTrue( socketLimit > 0,
                "Default value for socketLimit > 0" )
            XCTAssertTrue( try context.getMaxSockets() <= socketLimit,
                "Default value for maxSockets <= socketLimit" )
            let newMaxSockets = 2
            try context.setMaxSockets(newMaxSockets)
            XCTAssertTrue( try context.getMaxSockets() == newMaxSockets,
                           "maxSockets setter works" )

            // ipv6Enabled
            XCTAssertFalse( try context.isIPV6Enabled(),
                            "Default value for IPV6Enabled is false" )
            let newIpv6Enabled = true
            try context.setIPV6Enabled(newIpv6Enabled)
            XCTAssertTrue( try context.isIPV6Enabled() == newIpv6Enabled,
                           "IPV6Enabled setter works" )

            // setThreadPriority
            try context.setThreadPriority(10)
            XCTAssertTrue(true, "Context setThreadPriority works")

            // setThreadSchedulingPolicy
            try context.setThreadSchedulingPolicy(5)
            XCTAssertTrue(true, "Context setThreadSchedulingPolicy works")

        } catch {
            XCTFail("Context tests failure")
        }
    }

    func testSocket() {
        do {
            // Test creation of all socket types
            let socketTypes : [SwiftyZeroMQ.SocketType] = [
                .request, .reply, .router, .dealer, .publish, .subscribe,
                .xpublish, .xsubscribe, .push, .pull, .pair, .stream
            ]
            for socketType in socketTypes {
                let context = try SwiftyZeroMQ.Context()
                let socket = try context.socket(socketType)
                XCTAssertTrue(socket.handle != nil, "socket.handle is not nil")
                XCTAssertTrue(true, "\(socketType) socket created")
            }

        } catch {
            XCTFail("Socket tests failure")
        }
    }

    /**
        Test a simple request-reply pattern example without blocking
     */
    func testRequestReplyPattern() {
        do {
            // Define a TCP endpoint along with the text that we are going to send/recv
            let endpoint     = "tcp://127.0.0.1:5555"
            let textToBeSent = "Hello world"

            // Request socket
            let context      = try SwiftyZeroMQ.Context()
            let requestor    = try context.socket(.request)
            try requestor.connect(endpoint)

            // Reply socket
            let replier      = try context.socket(.reply)
            try replier.bind(endpoint)

            // Send it without waiting and check the reply on other socket
            try requestor.send(string: textToBeSent, options: .dontWait)
            let reply = try replier.recv()
            XCTAssertTrue(reply == textToBeSent, "Got the reply that we sent over ZeroMQ socket")

        } catch {
            XCTFail("Request-reply pattern failure")
        }
    }

}
