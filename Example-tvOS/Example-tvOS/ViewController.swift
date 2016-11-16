//
// Copyright (c) 2016 Ahmad M. Zawawi (azawawi)
//
// This package is distributed under the terms of the MIT license.
// Please see the accompanying LICENSE file for the full text of the license.
//

import UIKit
import SwiftyZeroMQ

class ViewController: UIViewController {
    @IBOutlet weak var versionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show version information
        let frameworkVersion = SwiftyZeroMQ.frameworkVersion
        let version = SwiftyZeroMQ.version.versionString
        versionTextView.text =
            "SwiftyZeroMQ version is \(frameworkVersion)\n" +
        "ZeroMQ library version is \(version)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
