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

    /// Inverse of `center(of:)`; nil when the point is outside the grid.
    public func coordinate(at point: CGPoint) -> GridPoint? {
        guard cellLength > 0, point.x >= 0, point.y >= 0 else { return nil }
        let column = Int(point.x / cellLength)
        let row = Int(point.y / cellLength)
        guard row >= 0, row < dotsPerSide, column >= 0, column < dotsPerSide else { return nil }
        return GridPoint(row, column)
    }

    public func dot(near point: CGPoint) -> GridPoint? {
        guard let cell = coordinate(at: point) else { return nil }
        let center = center(of: cell)
        let dx = point.x - center.x
        let dy = point.y - center.y
        let hotRadius = cellLength * 0.4
        return dx * dx + dy * dy <= hotRadius * hotRadius ? cell : nil
    }

    public static func straightLine(from start: GridPoint, to end: GridPoint) -> [GridPoint] {
        if start.row == end.row {
            let step = end.column > start.column ? 1 : -1
            return stride(from: start.column + step, to: end.column, by: step)
                .map { GridPoint(start.row, $0) }
        }
        if start.column == end.column {
            let step = end.row > start.row ? 1 : -1
            return stride(from: start.row + step, to: end.row, by: step)
                .map { GridPoint($0, start.column) }
        }
        return []
    }
}
