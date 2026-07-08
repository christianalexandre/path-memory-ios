import Dependencies
import SharedModels

public protocol PathGenerator: Sendable {
    func generate(_ config: GameConfig) -> GamePath
}

/// Deterministic serpentine truncated to the configured length; the randomized
/// generator arrives with the real game rules.
public struct StubPathGenerator: PathGenerator {
    public init() {}

    public func generate(_ config: GameConfig) -> GamePath {
        let size = config.gridSize
        var cells: [Coordinate] = []
        cells.reserveCapacity(size * size)
        for row in 0 ..< size {
            let columns = row.isMultiple(of: 2) ? Array(0 ..< size) : Array((0 ..< size).reversed())
            for column in columns {
                cells.append(Coordinate(row: row, column: column))
            }
        }
        let count = min(max(config.pathLength, 2), cells.count)
        return GamePath(Array(cells.prefix(count)))
    }
}

private enum PathGeneratorKey: DependencyKey {
    static let liveValue: any PathGenerator = StubPathGenerator()
}

public extension DependencyValues {
    var pathGenerator: any PathGenerator {
        get { self[PathGeneratorKey.self] }
        set { self[PathGeneratorKey.self] = newValue }
    }
}
