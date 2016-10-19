/*
Copyright (c) 2016 Ahmad M. Zawawi (azawawi)

This package is distributed under the terms of the MIT license.
Please see the accompanying LICENSE file for the full text of the license.
*/

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
        let (major, minor, patch) = ZeroMQ.version
        XCTAssertTrue(major == 4, "Major version is 4")
        XCTAssertTrue(minor == 1, "Minor version is 1")
        XCTAssertTrue(patch == 5, "Patch version is 5")

        let versionString = ZeroMQ.versionString
        XCTAssertTrue(versionString == "\(major).\(minor).\(patch)")
    }

    func testHas() {
        let _ = ZeroMQ.has(.ipc)
        XCTAssertTrue(true, ".ipc works")

        let _ = ZeroMQ.has(.pgm)
        XCTAssertTrue(true, ".pgm works")

        let _ = ZeroMQ.has(.tipc)
        XCTAssertTrue(true, ".tipc works")

        let _ = ZeroMQ.has(.norm)
        XCTAssertTrue(true, ".norm works")

        let _ = ZeroMQ.has(.curve)
        XCTAssertTrue(true, ".curve works")

        let _ = ZeroMQ.has(.gssapi)
        XCTAssertTrue(true, ".gssapi works")
    }

    func testContext() {
        do {
            let context = try ZeroMQ.Context()
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
            let socketTypes : [ZeroMQ.SocketType] = [
                .request, .reply, .router, .dealer, .publish, .subscribe,
                .xpublish, .xsubscribe, .push, .pull, .pair, .stream
            ]
            for socketType in socketTypes {
                let context = try ZeroMQ.Context()
                let socket = try context.socket(socketType)
                XCTAssertTrue(socket.handle != nil, "socket.handle is not nil")
                XCTAssertTrue(true, "\(socketType) socket created")
            }

        } catch {
            XCTFail("Socket tests failure")
        }
    }

    func testPoller() {
        // Test for unimplemented for now
        XCTAssertThrowsError(try ZeroMQ.Poller())
    }

}
