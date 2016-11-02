//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import Cocoa
import SwiftyZeroMQ

class ViewController: NSViewController {

    @IBOutlet var versionTextView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show version information
        let frameworkVersion = SwiftyZeroMQ.frameworkVersion
        let version = SwiftyZeroMQ.version.versionString
        versionTextView.textStorage?.append(
            NSAttributedString(
                string:
                    "SwiftyZeroMQ version is \(frameworkVersion!)\n" +
                    "ZeroMQ library version is \(version)"
            )
        )
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

