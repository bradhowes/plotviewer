// Copyright © 2019 Brad Howes. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signalView: PlotView!
    @IBOutlet weak var minX: UILabel!
    @IBOutlet weak var maxX: UILabel!
    @IBOutlet weak var minY: UILabel!
    @IBOutlet weak var maxY: UILabel!

    var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = PlotViewLabelsFormatter(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        let frameUpdating: (CGRect) -> Void = { formatter.update(frame: $0) }

        self.observation = observe(\.signalView.plotViewFrame, options: [.new]) { obj, change in
            guard let frame = change.newValue else { return }
            frameUpdating(frame)
        }

        frameUpdating(signalView.plotViewFrame)
    }
}
