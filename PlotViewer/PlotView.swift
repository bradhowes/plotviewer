// Copyright © 2019 Brad Howes. All rights reserved.

import UIKit

/**
 Simple view which shows a sine wave over X [0, 2] and Y from [-1.0, 1.0]. Supports panning and zooming of the view.
 View changes calculate new sets of points which are then used to generate a CAShape path for rendering.
 */
final class PlotView: UIView {

    /// The default plot view coordinate space. This follows normal mathematical convention where negative Y values are
    /// below positive Y values. View changes are constrained to always reside within this coordinate space.
    static let maxPlotViewFrame = CGRect(x: 0.0, y: -1.0, width: 2.0, height: 2.0)

    /// Minimum plotViewFrame size.
    static let minPlotViewFrameSize = CGSize(width: 0.01, height: 0.01)

    /// The CA layer that will render the sinusoid.
    private let plotLayer = CAShapeLayer()

    /// The current plot view coordinate space.
    @objc dynamic public private(set) var plotViewFrame: CGRect = maxPlotViewFrame {
        didSet { generateTransform() }
    }

    /// The current transform used to render plot points in device coordinates.
    private var plotTransform: CGAffineTransform = .identity {
        didSet { inverseTransform = plotTransform.inverted() }
    }

    /// The inverse of the current transform.
    private var inverseTransform: CGAffineTransform = .identity {
        didSet { generatePath() }
    }

    /// The start location of a pan gesture
    private var viewOriginAtPanStart = CGPoint.zero

    /// The active plotViewFrame of a pinch gesture
    private var plotFrameAtPinchStart = maxPlotViewFrame

    /**
     Construct a new view instance.

     - parameter frame: the geometry of the view
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    /**
     Reconstruct a new view instance using settings read from an NSCoder.

     - parameter coder: the container that holds configuration settings for this view
     */
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        plotLayer.frame.size = bounds.size
        generateTransform()
    }
}

// MARK: - Gesture Handlers

extension PlotView {

    /**
     Process a panning gesture.

     - parameter sender: the UIPanGestureRecognizer tracking a pan
     */
    @IBAction private func panGesture(_ sender: UIPanGestureRecognizer) {

        // Record the view origin at the start of the pan, and then update it with delta values from the sender after
        // converting them from device to plot coordinate space. Since these are just deltas and we don't have any
        // rotations, the conversion is straightforward application of two values from the inverse transform.

        if sender.state == .began {
            viewOriginAtPanStart = plotViewFrame.origin
        }

        let deviceDelta = sender.translation(in: self)
        let plotViewDelta = CGVector(dx: deviceDelta.x * inverseTransform.a, dy: deviceDelta.y * inverseTransform.d)
        plotViewFrame = CGRect(origin: clampToMaxPlotViewFrame(viewOriginAtPanStart - plotViewDelta),
                               size: plotViewFrame.size)
    }

    /**
     Process a pinching gesture.

     - parameter sender: the UIPinchGestureRecognizer tracking a zoom
     */
    @IBAction private func pinchGesture(_ sender: UIPinchGestureRecognizer) {

        // Record the plot view frame at the start of the zoom, and then update the view size with scale values from
        // the sender.

        if sender.state == .began {
            plotFrameAtPinchStart = plotViewFrame
        }
        else if sender.state == .cancelled {
            plotViewFrame = plotFrameAtPinchStart
        }
        else if sender.state == .changed {
            let newSize = (plotFrameAtPinchStart.size / sender.scale).constrained(from: Self.minPlotViewFrameSize,
                                                                                  to: Self.maxPlotViewFrame.size)
            let newOrigin = plotFrameAtPinchStart.center - newSize / 2
            plotViewFrame = CGRect(origin: clampToMaxPlotViewFrame(newOrigin), size: newSize)
        }
    }
}

// MARK: - Private Methods

extension PlotView {

    /**
     Initialize new instance.
     */
    private func initialize() {
        plotLayer.lineWidth = 1.0
        plotLayer.strokeColor = UIColor.green.cgColor
        plotLayer.fillColor = nil
        layer.addSublayer(plotLayer)
        installGestureRecognizers()
        plotViewFrame = Self.maxPlotViewFrame
    }

    private func installGestureRecognizers() {
        let gr1 = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        gr1.minimumNumberOfTouches = 1
        gr1.maximumNumberOfTouches = 1
        addGestureRecognizer(gr1)

        let gr2 = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        addGestureRecognizer(gr2)
    }

    /**
     Generate a CGAffineTransform that matches the current plotViewFrame. The Y values look odd due to the mapping
     of plot Y space into CoreGraphics Y values which from 0 at top of frame to frame.width at the bottom of the
     view frame.
     */
    private func generateTransform() {
        let yScale = bounds.height / plotViewFrame.height
        plotTransform = CGAffineTransform.identity
            .scaledBy(x: bounds.width / plotViewFrame.width, y: -yScale)
            .translatedBy(x: -plotViewFrame.minX, y: -(plotViewFrame.height + plotViewFrame.minY))
    }

    /**
     Generate a new CGPath for the points in the plotViewFrame.
     */
    private func generatePath() {
        let step = plotViewFrame.width / bounds.width
        let vertices = stride(from: plotViewFrame.minX, through: plotViewFrame.maxX, by: step)
            .map { CGPoint(x: $0, y: sin($0 * .pi * 5.0) * $0 / 2.0) }

        let path = CGMutablePath()
        path.move(to: vertices[0], transform: plotTransform)
        path.addLines(between: vertices, transform: plotTransform)
        plotLayer.path = path
    }

    /**
     Constrain the given point so that a plotViewFrame with it as an origin is always within maxPlotViewFrame.

     - parameter point: the point to constrain
     - returns: a point guaranteed to be inside the constaint area
     */
    private func clampToMaxPlotViewFrame(_ point: CGPoint) -> CGPoint {
        return point.constrained(to: CGRect(origin: Self.maxPlotViewFrame.origin,
                                            size: Self.maxPlotViewFrame.size - plotViewFrame.size))
    }
}
