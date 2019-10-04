//
//  ViewController.swift
//  PlotTransforms
//
//  Created by Brad Howes on 9/29/19.
//  Copyright © 2019 Brad Howes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signalView: PlotView!
    @IBOutlet weak var minX: UILabel!
    @IBOutlet weak var maxX: UILabel!
    @IBOutlet weak var minY: UILabel!
    @IBOutlet weak var maxY: UILabel!

    var formatter: PlotViewLabelsFormatter?
    var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatter = PlotViewLabelsFormatter(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        self.observation = observe(\.signalView.plotViewFrame, options: [.new]) { obj, change in
            if let frame = change.newValue, let formatter = self.formatter { formatter.update(frame: frame) }
        }

        self.formatter?.update(frame: signalView.plotViewFrame)
    }
}
