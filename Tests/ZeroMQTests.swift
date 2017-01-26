//
// Copyright (c) 2016-2017 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import XCTest
@testable import SwiftyZeroMQ

class ZeroMQTests: XCTestCase {

    func testVersion() {
        let (major, minor, patch, versionString) = SwiftyZeroMQ.version
        XCTAssertTrue(major == 4, "Major version is 4")
        XCTAssertTrue(minor == 2, "Minor version is 2")
        XCTAssertTrue(patch == 2, "Patch version is 2")
        XCTAssertTrue(versionString == "\(major).\(minor).\(patch)")

        let frameworkVersion = SwiftyZeroMQ.frameworkVersion
        let regex = "^\\d+\\.\\d+\\.\\d+$"
        XCTAssertTrue(frameworkVersion.range(of: regex, options : .regularExpression) != nil)
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

            // blocky
            XCTAssertTrue( try context.isBlocky(),
                           "Default value for blocky is true" )
            let newBlockyValue = false
            try context.setBlocky(newBlockyValue)
            XCTAssertTrue( try context.isBlocky() == newBlockyValue,
                           "blocky setter works" )

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

            // maxMessageSize
            XCTAssertTrue( try context.getMaxMessageSize() == Int(Int32.max),
                           "Default value for max message size is Int32.max" )
            let newMaxMessageSize = 4096
            try context.setMaxMessageSize(newMaxMessageSize)
            XCTAssertTrue( try context.getMaxMessageSize() == newMaxMessageSize,
                           "maxMessageSize setter works" )

            // setThreadSchedulingPolicy
            try context.setThreadSchedulingPolicy(5)
            XCTAssertTrue(true, "Context setThreadSchedulingPolicy works")

            // Hashable
            let c1 = try SwiftyZeroMQ.Context()
            let c2 = try SwiftyZeroMQ.Context()
            let contextMap = [ c1: "c1", c2: "c2"]
            XCTAssertTrue(contextMap[c1] == "c1", "Correct string value for c1")
            XCTAssertTrue(contextMap[c2] == "c2", "Correct string value for c2")

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

            // Hashable
            let context = try SwiftyZeroMQ.Context()
            let s1      = try context.socket(.request)
            let s2      = try context.socket(.request)
            let socketMap = [ s1: "s1", s2: "s2"]
            XCTAssertTrue(socketMap[s1] == "s1", "Correct string value for s1")
            XCTAssertTrue(socketMap[s2] == "s2", "Correct string value for s2")

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
