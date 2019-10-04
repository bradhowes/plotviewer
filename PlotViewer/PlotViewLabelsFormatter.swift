// Copyright © 2019 Brad Howes. All rights reserved.

import UIKit

/**
 Manages the labels that show the axis bounds of the current plot view frame. Updates cause the labels to appear
 with full intensity, and then they fade after a few seconds.
 */
struct PlotViewLabelsFormatter {

    /// Collection of tuples that pair a label with a function that gets the associated property from a CGRect
    private let labels: [(UILabel, (CGRect)->CGFloat)]

    /// Number formatter for the CGFloat values shown in the labels
    private let labelFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 1
        formatter.minimumIntegerDigits = 1
        return formatter
    }()

    /**
     Initialize instance with collection of UILabel instances to manage.

     - parameter minX: the smallest X value being displayed
     - parameter maxX: the largest X value being displayed
     - parameter minY: the smallest Y value being displayed
     - parameter maxY: the largest Y value being displayed
     */
    init(minX: UILabel, maxX: UILabel, minY: UILabel, maxY: UILabel) {
        self.labels = [(minX, {$0.minX}), (maxX, {$0.maxX}), (minY, {$0.minY}), (maxY, {$0.maxY})]
    }

    /**
     Update the labels using the values from the given CGRect. Makes the labels visible with the new values, and
     sets them up to fade after a short delay.

     - parameter frame: the coordinate space to show
     */
    func update(frame: CGRect) {
        labels.forEach { label, getter in
            label.text = labelFormatter.string(for: getter(frame))
            label.alpha = 1.0
        }
        doFade { self.labels.forEach { $0.0.alpha = 0.2 } }
    }

    private func doFade(_ fader: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, delay: 1.2, options: [.curveEaseOut], animations: fader)
    }
}
