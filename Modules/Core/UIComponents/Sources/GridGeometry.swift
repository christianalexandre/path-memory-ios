import CoreGraphics

/// Position on the dot grid, zero-based from the top-left corner.
public struct GridPoint: Hashable, Sendable {
    public let row: Int
    public let column: Int

    public init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}

public struct GridMetrics: Equatable, Sendable {
    public let dotsPerSide: Int
    public let sideLength: CGFloat

    public init(dotsPerSide: Int, sideLength: CGFloat) {
        self.dotsPerSide = dotsPerSide
        self.sideLength = sideLength
    }

    public var cellLength: CGFloat {
        sideLength / CGFloat(max(dotsPerSide, 1))
    }

    public var dotDiameter: CGFloat {
        min(cellLength * 0.46, 30)
    }

    public var trailWidth: CGFloat {
        max(3, cellLength * 0.09)
    }

    public var ghostTrailWidth: CGFloat {
        max(2, cellLength * 0.05)
    }

    public func center(of point: GridPoint) -> CGPoint {
        CGPoint(
            x: (CGFloat(point.column) + 0.5) * cellLength,
            y: (CGFloat(point.row) + 0.5) * cellLength
        )
    }
}
