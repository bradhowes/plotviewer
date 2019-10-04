// Copyright © 2019 Brad Howes. All rights reserved.

import UIKit

/**
 Manages the labels that show the axis bounds of the current plot view frame. Updates cause the labels to appear
 with full intensity, and then they fade after a few seconds.
 */
struct PlotViewLabelsFormatter {
    private let labels: [UILabel]
    private let getters: [(CGRect)->CGFloat] // keyPath-like behavior for CGRect boundary values

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 1
        return formatter
    }()

    init(minX: UILabel, maxX: UILabel, minY: UILabel, maxY: UILabel) {
        self.labels = [minX, maxX, minY, maxY]
        self.getters = [{$0.minX}, {$0.maxX}, {$0.minY}, {$0.maxY}]
    }

    func update(frame: CGRect) {
        zip(labels, getters).forEach { label, getter in
            label.text = formatter.string(for: getter(frame))
            label.alpha = 1.0
        }
        doFade { self.labels.forEach { $0.alpha = 0.2 } }
    }

    private func doFade(_ fader: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, delay: 1.2, options: [.curveEaseOut], animations: fader)
    }
}
