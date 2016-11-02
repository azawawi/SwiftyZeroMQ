//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import WatchKit
import Foundation
import SwiftyZeroMQ


class InterfaceController: WKInterfaceController {
    @IBOutlet var versionLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Show version information
        let frameworkVersion = SwiftyZeroMQ.frameworkVersion
        let version = SwiftyZeroMQ.version.versionString
        versionLabel.setText(
            "SwiftyZeroMQ version is \(frameworkVersion!)\n" +
            "ZeroMQ library version is \(version)"
        )
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
