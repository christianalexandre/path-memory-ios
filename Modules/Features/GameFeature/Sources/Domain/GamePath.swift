import SharedModels

/// Named `GamePath` to avoid clashing with `SwiftUI.Path`.
public struct GamePath: Equatable, Sendable {
    public let coordinates: [Coordinate]

    public init(_ coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }

    public var start: Coordinate? {
        coordinates.first
    }

    public var end: Coordinate? {
        coordinates.last
    }

    public var length: Int {
        coordinates.count
    }

    /// Oriented to start at `endpoint`, or nil if it isn't one of the two ends.
    public func sequence(startingAt endpoint: Coordinate) -> [Coordinate]? {
        if endpoint == coordinates.first {
            return coordinates
        }
        if endpoint == coordinates.last {
            return Array(coordinates.reversed())
        }
        return nil
    }

    public func matches(_ attempt: [Coordinate]) -> Bool {
        attempt == coordinates || attempt == Array(coordinates.reversed())
    }
}
