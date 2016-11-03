//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//


/**
    Utility functions are provided here such as version, capability and proxy
 */
public struct SwiftyZeroMQ {

    /**
        Private constructor to prevent instansiation
     */
    private init() {
      // Do nothing
    }

    /**
        Represents a capability or feature that ZeroMQ supports.
        * ipc    - the library supports the ipc:// protocol
        * pgm    - the library supports the pgm:// protocol
        * tipc   - the library supports the tipc:// protocol
        * norm   - the library supports the norm:// protocol
        * curve  - the library supports the CURVE security mechanism
        * gssapi - the library supports the GSSAPI security mechanism
     */
    public enum Capability : String {
        case ipc
        case pgm
        case tipc
        case norm
        case curve
        case gssapi
    }

    /**
        Returns the version information tuple as (.major, .minor, .patch, .versionString)
     */
    public static var version : (major: Int, minor: Int, patch: Int, versionString: String) {
        var major: Int32 = 0
        var minor: Int32 = 0
        var patch: Int32 = 0
        zmq_version(&major, &minor, &patch)
        let versionString = "\(major).\(minor).\(patch)"

        return ( Int(major), Int(minor), Int(patch), versionString)
    }

    /**
        Returns the framework version as a string
     */
    public static var frameworkVersion : String? {
        //
        // Try to find out framework bundle version for different bundle identifiers
        // Reason: CocoaPods does not provide a way to set the bundle identifier
        // Please see https://github.com/CocoaPods/CocoaPods/issues/3032
        //
        let ids = ["org.azawawi.SwiftyZeroMQ", "org.cocoapods.SwiftyZeroMQ"]
        let key = "CFBundleShortVersionString"
        for id in ids {
            if let version = Bundle(identifier: id)?.infoDictionary?[key] as? String {
                return version
            }
        }

        // For some odd reason, we failed miserably
        return nil
    }

    /**
        Returns whether the capability is enabled or not
     */
    public static func has(_ capability : Capability) -> Bool {
        return zmq_has(capability.rawValue) == 1
    }

    /**
        The proxy connects a frontend socket to a backend socket. Conceptually,
        data flows from frontend to backend. Depending on the socket types,
        replies may flow in the opposite direction. The direction is conceptual
        only; the proxy is fully symmetric and there is no technical difference
        between frontend and backend.

        If the capture socket is not nil, the proxy shall send all messages,
        received on both frontend and backend, to the capture socket. The
        capture socket should be a .publish, .dealer, .push, or .pair typed
        socket.
     */
    public static func proxy(
        frontend : SwiftyZeroMQ.Socket,
        backend  : SwiftyZeroMQ.Socket,
        capture  : SwiftyZeroMQ.Socket? = nil) throws
    {
        let result = zmq_proxy(frontend.handle, backend.handle, capture?.handle)
        if result == -1 {
            throw ZeroMQError.last
        }
    }

}
