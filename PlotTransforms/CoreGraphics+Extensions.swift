//  Copyright © 2019 Brad Howes. All rights reserved.

import CoreGraphics

/// Convenience functions for CGRect.
public extension CGRect {

    /// Obtain the center of a CGRect.
    @inlinable
    var center: CGPoint { return CGPoint(x: midX, y: midY) }

    /**
     Create a new rectangle which has a center at the given point.

     - parameter at: the center point
     - returns: new CGRect centered at given point
     */
    @inlinable
    func centered(at: CGPoint) -> CGRect {
        return CGRect(origin: CGPoint(x: at.x - width / 2.0, y: at.y - height / 2.0), size: size)
    }

    /**
     Constrain the rect to be within the bounds of another. Note that this is undefined if the bounding rectangle
     is smaller in any dimension than our own.

     - parameter bounds: the constraining bounds
     - returns: new CGRect that lies within the rectangle
     */
    @inlinable
    func constrained(to bounds: CGRect) -> CGRect {
        let dx = minX < bounds.minX ? bounds.minX - minX : (maxX > bounds.maxX ? bounds.maxX - maxX : 0.0)
        let dy = minY < bounds.minY ? bounds.minY - minY : (maxY > bounds.maxY ? bounds.maxY - maxY : 0.0)
        return self + CGVector(dx: dx, dy: dy)
    }

    /**
     Add a CGVector to the origin of a CGRect.

     - parameter lhs: the rect to operate on
     - parameter rhs: the vector to add
     - returns: new CGRect moved by the offsets in the CGVector
     */
    @inlinable
    static func +(lhs: CGRect, rhs: CGVector) -> CGRect {
        return CGRect(origin: lhs.origin + rhs, size: lhs.size)
    }

    /**
     Subtract a CGVector from the origin of a CGRect.

     - parameter lhs: the rect to operate on
     - parameter rhs: the vector to subtract
     - returns: new CGRect moved by the offsets in the CGVector
     */
    @inlinable
    static func -(lhs: CGRect, rhs: CGVector) -> CGRect {
        return CGRect(origin: lhs.origin - rhs, size: lhs.size)
    }
}

/// Convenience functions for CGVector.
public extension CGVector {

    /**
     Convert from a CGPoint, treating the coordinates as deltas rather than absolute values.

     - parameter value: the CGPoint to use
     */
    @inlinable
    init(_ value: CGPoint) {
        self.init(dx: value.x, dy: value.y)
    }

    /**
     Convert from a CGSize.

     - parameter value: the CGSize to use
     */
    @inlinable
    init(_ value: CGSize) {
        self.init(dx: value.width, dy: value.height)
    }

    /**
     Add two CGVector values
     - parameter lhs: the CGVector to add
     - parameter rhs: the CGVector to add
     - returns: new CGVector representing the sum
     */
    @inlinable
    static func +(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    /**
     Subtract two CGVector values
     - parameter lhs: the CGVector to subtract
     - parameter rhs: the CGVector to subtract
     - returns: new CGVector representing the sum
     */
    @inlinable
    static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    /**
     Add CGSize with CGVector
     - parameter lhs: the CGSize to add
     - parameter rhs: the CGVector to add
     - returns: new CGSize representing the sum
     */
    @inlinable
    static func +(lhs: CGVector, rhs: CGSize) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.width, dy: lhs.dy + rhs.height)
    }

    /**
     Subtract CGVector from CGSize
     - parameter lhs: the CGSize to subtract from
     - parameter rhs: the CGVector to subtract
     - returns: new CGSize representing the difference
     */
    @inlinable
    static func -(lhs: CGVector, rhs: CGSize) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.width, dy: lhs.dy - rhs.height)
    }

    /**
     Multiply the components of a CGVector by a scalar
     - parameter lhs: the CGVector to multiply
     - parameter rhs: the scalar to muliply
     - returns new CGVector
     */
    @inlinable
    static func *<T>(lhs: CGVector, rhs: T) -> CGVector where T: BinaryFloatingPoint {
        let scalar = CGFloat(rhs)
        return CGVector(dx: lhs.dx * scalar, dy: lhs.dy * scalar)
    }

    /**
     Divide the components of a CGVector by a scalar
     - parameter lhs: the CGVector to divide
     - parameter rhs: the scalar to divide by
     - returns new CGVector
     */
    @inlinable
    static func /<T>(lhs: CGVector, rhs: T) -> CGVector where T: BinaryFloatingPoint {
        let scalar = CGFloat(rhs)
        return CGVector(dx: lhs.dx / scalar, dy: lhs.dy / scalar)
    }

    /// Obtain the squared magnitude of the CGVector
    @inlinable var magnitude2: CGFloat { return dx * dx + dy * dy }

    /// Obtain the magnitude of the CGVector
    @inlinable var magnitude: CGFloat { return sqrt(magnitude2) }
}

/// Convenience functions for CGPoint.
public extension CGPoint {

    /**
     Add the components of a CGPoint and a CGVector
     - parameter lhs: the CGPoint to add
     - parameter rhs: the CGVector to add
     - returns: new CGPoint representing the sum
     */
    @inlinable
    static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    /**
     Subtract the components of a CGPoint and a CGVector
     - parameter lhs: the CGPoint to subtract
     - parameter rhs: the CGVector to subtract
     - returns: new CGPoint representing the difference
     */
    @inlinable
    static func -(lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }

    /**
     Add the components of a CGPoint and a CGSize
     - parameter lhs: the CGPoint to add
     - parameter rhs: the CGSize to add
     - returns: new CGPoint representing the sum
     */
    @inlinable
    static func +(lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }

    /**
     Subtract the components of a CGPoint and a CGSize
     - parameter lhs: the CGPoint to subtract
     - parameter rhs: the CGSize to subtract
     - returns: new CGPoint representing the difference
     */
    @inlinable
    static func -(lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }

    /**
     Subtract the components of two CGPoint values and return as CGVector
     - parameter lhs: the CGPoint to subtract
     - parameter rhs: the CGPoint to subtract
     - returns: new CGVector representing the difference
     */
    @inlinable
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGVector {
        return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    /**
     Constrain a point so that it falls within a given boundary.

     - parameter bounds: the boundary to constrain to
     - returns: a CGPoint whose value is within the given boundary
     */
    @inlinable
    func constrained(to bounds: CGRect) -> CGPoint {
        return CGPoint(x: min(max(self.x, bounds.minX), bounds.maxX), y: min(max(self.y, bounds.minY), bounds.maxY))
    }
}

/// Convenience functions for CGSize.
public extension CGSize {

    /**
     Convert from a CGVector.

     - parameter value: the CGVector to use
     */
    @inlinable
    init(_ value: CGVector) {
        self.init(width: value.dx, height: value.dy)
    }

    /**
     Add two CGSize values
     - parameter lhs: the CGSize to add
     - parameter rhs: the CGSize to add
     - returns: new CGSize representing the sum
     */
    @inlinable
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /**
     Subtract two CGSize values
     - parameter lhs: the CGSize to subtract
     - parameter rhs: the CGSize to subtract
     - returns: new CGSize representing the sum
     */
    @inlinable
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /**
     Add CGSize with CGVector
     - parameter lhs: the CGSize to add
     - parameter rhs: the CGVector to add
     - returns: new CGSize representing the sum
     */
    @inlinable
    static func +(lhs: CGSize, rhs: CGVector) -> CGSize {
        return CGSize(width: lhs.width + rhs.dx, height: lhs.height + rhs.dy)
    }

    /**
     Subtract CGVector from CGSize
     - parameter lhs: the CGSize to subtract from
     - parameter rhs: the CGVector to subtract
     - returns: new CGSize representing the difference
     */
    @inlinable
    static func -(lhs: CGSize, rhs: CGVector) -> CGSize {
        return CGSize(width: lhs.width - rhs.dx, height: lhs.height - rhs.dy)
    }

    /**
     Multiply the components of a CGSize value by a scalar
     - parameter lhs: the CGSize to multiply
     - parameter rhs: the scalar to multiply
     - returns: new CGSize representing the result
     */
    @inlinable
    static func *<T>(lhs: CGSize, rhs: T) -> CGSize where T: BinaryFloatingPoint {
        let scalar = CGFloat(rhs)
        return CGSize(width: lhs.width * CGFloat(scalar), height: lhs.height * CGFloat(scalar))
    }

    /**
     Divide the components of a CGSize value by a scalar
     - parameter lhs: the CGSize to divide
     - parameter rhs: the scalar to divide
     - returns: new CGSize representing the result
     */
    @inlinable
    static func /<T>(lhs: CGSize, rhs: T) -> CGSize where T: BinaryFloatingPoint {
        let scalar = CGFloat(rhs)
        return CGSize(width: lhs.width / CGFloat(scalar), height: lhs.height / CGFloat(scalar))
    }

    /**
     Constrain a size to be between two other CGSize values

     - parameter minSize: the smallest value allowed
     - parameter maxSize: the largets value allowed
     - returns: constrained size value
     */
    @inlinable
    func constrained(from minSize: CGSize, to maxSize: CGSize) -> CGSize {
        return CGSize(width: min(max(self.width, minSize.width), maxSize.width),
                      height: min(max(self.height, minSize.height), maxSize.height))
    }
}
