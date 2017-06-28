//
//  ZMQPatternsTests.swift
//  SwiftyZeroMQ
//
//  Created by Thomas Bibby on 28/06/2017.
//  Copyright © 2017 azawawi. All rights reserved.
//

import XCTest
@testable import SwiftyZeroMQ

class ZMQPatternsTests: XCTestCase {
    //    Previously generated public and private keys for server
    let server_public_key = ".s&p=^57A5>h-Xgyv%mJX58}C)]fLp9&t{xl[LR]"
    let server_private_key = "gJ4jDw>ZdY1eASGv2R{<u/ZMB8:$wYG4km:g{lp>"
    private let endpoint = "tcp://127.0.0.1:5550"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testSecurePushPullSocket() throws {
        if(!SwiftyZeroMQ.has(.curve)) {
            XCTFail("Cannot test CURVE as SwiftyZeroMQ does not have CURVE enabled")
        }
        //we will compare these two in our assert at the end
        let messageToSend = "YORE MA"
        var messageReceived = ""
        
        
        let context = try SwiftyZeroMQ.Context()
        let subSocket = try context.socket(.pull)
        //    Generated keys for the client
        let (generated_public_key, generated_private_key) = try subSocket.curveKeyPair()
        //    Connect up client socket
        try subSocket.setupCurveSecurityOnClientWithServerPublicKey(server_public_key, clientPublicKey: generated_public_key, clientSecretKey: generated_private_key)
        print("Client socket now set up, moving on...")
        //now set up server socket
        let pubSocket = try context.socket(.push)
        try pubSocket.setupCurveSecurityOnServerWithServerSecretKey(server_private_key, serverPublicKey: server_public_key)
        print("Finished setting up server socket")
        //bind the pub socket and connect the sub socket to it
        try pubSocket.bind(endpoint)
        try subSocket.connect(endpoint)
        //    Send up our message
        try pubSocket.send(string: messageToSend)
        //    sync wait for message to come in
        messageReceived = try! subSocket.recv()!
        
        XCTAssert(messageReceived == messageToSend)
        
    }
    
    func testPubSubWithoutCurve() throws {
        //    we will compare these in our XCTAssert
        let messageToSend = "YORE MA"
        var messageReceived = ""
        let context = try SwiftyZeroMQ.Context()
        
        //do sub socket first
        let subSocket = try context.socket(.subscribe)
        //just subscribe to everything
        try subSocket.setSubscribe("YORE")
        try subSocket.connect(endpoint)
        usleep(1000)
        
        let pubSocket = try context.socket(.publish)
        
        try pubSocket.bind(endpoint)
        
        sleep(1)
        try pubSocket.send(string: messageToSend)
        if let result = try subSocket.recv() {
            messageReceived = result
        }
        print("message to send: \(messageToSend), message received: \(messageReceived)")
        XCTAssert(messageToSend == messageReceived)
        
        
    }
    
    func testPubSubWithCurve() throws {
        let messageToSend = "YORE MA"
        var messageReceived = ""
        
        
        
        
        let context = try SwiftyZeroMQ.Context()
        
        //do sub socket first
        let subSocket = try context.socket(.subscribe)
        //generate keys
        let (generated_public_key, generated_private_key) = try subSocket.curveKeyPair()
        //set security on sub socket
        try subSocket.setupCurveSecurityOnClientWithServerPublicKey(server_public_key, clientPublicKey: generated_public_key, clientSecretKey: generated_private_key)
        //just subscribe to everything
        try subSocket.setSubscribe(nil)
        try subSocket.connect(endpoint)
        usleep(1000)
        
        //setup sub socket
        let pubSocket = try context.socket(.publish)
        try pubSocket.setupCurveSecurityOnServerWithServerSecretKey(server_private_key, serverPublicKey: server_public_key)
        
        try pubSocket.bind(endpoint)
        
        sleep(1)
        try pubSocket.send(string: "YORE MA")
        //sync receive
        if let result = try subSocket.recv() {
            messageReceived = result
        }
        XCTAssert(messageToSend == messageReceived)
        
    }
    
    public func testDealerRouter() throws {
        let messageToSend = "O HAI"
        let identifierToSend = "EES ME"
        
        var identifierReceived = ""
        var messageReceived = ""
        
        //context
        let context = try SwiftyZeroMQ.Context()
        //router
        let routerSocket = try context.socket(.router)
        try routerSocket.bind(endpoint)
        
        //dealer
        let dealerSocket = try context.socket(.dealer)
        try dealerSocket.setStringSocketOption(ZMQ_IDENTITY, identifierToSend)
        try dealerSocket.connect(endpoint)
        
        try dealerSocket.send(string: messageToSend)
        //first message is the identifier
        identifierReceived = try routerSocket.recv()!
        //second message is our actual message
        messageReceived = try routerSocket.recv()!
        
        //check that the identifier we sent was the identifier we received
        XCTAssert(identifierToSend == identifierReceived)
        //check that the message we sent was the message we received
        XCTAssert(messageToSend == messageReceived)
    }
    
    public func testSecureDealerRouter() throws {
        if(!SwiftyZeroMQ.has(.curve)) {
            XCTFail("Cannot test CURVE as SwiftyZeroMQ does not have CURVE enabled")
        }
        let messageToSend = "O HAI"
        let identifierToSend = "EES ME"
        
        var identifierReceived = ""
        var messageReceived = ""
        
        //context
        let context = try SwiftyZeroMQ.Context()
        //router
        let routerSocket = try context.socket(.router)
        //set key
        try routerSocket.setupCurveSecurityOnServerWithServerSecretKey(server_private_key, serverPublicKey: server_public_key)
        
        try routerSocket.bind(endpoint)
        
        //dealer
        let dealerSocket = try context.socket(.dealer)
        try dealerSocket.setStringSocketOption(ZMQ_IDENTITY, identifierToSend)
        //generate client keypair
        let (clientPublicKey, clientPrivateKey) = try dealerSocket.curveKeyPair()
        try dealerSocket.setupCurveSecurityOnClientWithServerPublicKey(server_public_key, clientPublicKey: clientPublicKey, clientSecretKey: clientPrivateKey)
        
        try dealerSocket.connect(endpoint)
        
        try dealerSocket.send(string: messageToSend)
        //first message is the identifier
        identifierReceived = try routerSocket.recv()!
        //second message is our actual message
        messageReceived = try routerSocket.recv()!
        
        //check that the identifier we sent was the identifier we received
        XCTAssert(identifierToSend == identifierReceived)
        //check that the message we sent was the message we received
        XCTAssert(messageToSend == messageReceived)
    }
    
}

