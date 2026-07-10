import Dependencies
import SharedModels

public protocol PathGenerator: Sendable {
    func generate(_ config: GameConfig) -> GamePath
}

/// Randomized orthogonal self-avoiding walk truncated to the configured length,
/// so each phase draws a fresh shape. Falls back to a serpentine when the walk
/// can't reach the target length within budget (dense, near-full grids).
public struct RandomPathGenerator: PathGenerator {
    public init() {}

    public func generate(_ config: GameConfig) -> GamePath {
        var rng = SystemRandomNumberGenerator()
        return Self.generate(config, using: &rng)
    }

    /// Seam for deterministic testing.
    static func generate(_ config: GameConfig, using rng: inout some RandomNumberGenerator) -> GamePath {
        let size = config.gridSize
        let target = min(max(config.pathLength, 2), size * size)
        for _ in 0 ..< 12 {
            let start = Coordinate(
                row: Int.random(in: 0 ..< size, using: &rng),
                column: Int.random(in: 0 ..< size, using: &rng)
            )
            if let walk = walk(size: size, target: target, from: start, using: &rng) {
                return GamePath(walk)
            }
        }
        return GamePath(serpentine(size: size, target: target))
    }

    private static func walk(
        size: Int,
        target: Int,
        from start: Coordinate,
        using rng: inout some RandomNumberGenerator
    ) -> [Coordinate]? {
        var path: [Coordinate] = []
        var visited: Set<Coordinate> = []
        var budget = size * size * 60

        func neighbors(of cell: Coordinate) -> [Coordinate] {
            var result: [Coordinate] = []
            if cell.row > 0 { result.append(Coordinate(row: cell.row - 1, column: cell.column)) }
            if cell.row < size - 1 { result.append(Coordinate(row: cell.row + 1, column: cell.column)) }
            if cell.column > 0 { result.append(Coordinate(row: cell.row, column: cell.column - 1)) }
            if cell.column < size - 1 { result.append(Coordinate(row: cell.row, column: cell.column + 1)) }
            return result
        }

        func extend(from cell: Coordinate) -> Bool {
            path.append(cell)
            visited.insert(cell)
            if path.count == target { return true }
            budget -= 1
            if budget <= 0 { return false }
            for next in neighbors(of: cell).shuffled(using: &rng) where !visited.contains(next) {
                if extend(from: next) { return true }
            }
            path.removeLast()
            visited.remove(cell)
            return false
        }

        return extend(from: start) ? path : nil
    }

    /// Deterministic boustrophedon fill; always connected and non-crossing.
    static func serpentine(size: Int, target: Int) -> [Coordinate] {
        var cells: [Coordinate] = []
        cells.reserveCapacity(size * size)
        for row in 0 ..< size {
            let columns = row.isMultiple(of: 2) ? Array(0 ..< size) : Array((0 ..< size).reversed())
            for column in columns {
                cells.append(Coordinate(row: row, column: column))
            }
        }
        let count = min(max(target, 2), cells.count)
        return Array(cells.prefix(count))
    }
}

/// Deterministic serpentine; used in tests and previews for stable paths.
public struct StubPathGenerator: PathGenerator {
    public init() {}

    public func generate(_ config: GameConfig) -> GamePath {
        GamePath(RandomPathGenerator.serpentine(size: config.gridSize, target: config.pathLength))
    }
}

private enum PathGeneratorKey: DependencyKey {
    static let liveValue: any PathGenerator = RandomPathGenerator()
    static let testValue: any PathGenerator = StubPathGenerator()
}

public extension DependencyValues {
    var pathGenerator: any PathGenerator {
        get { self[PathGeneratorKey.self] }
        set { self[PathGeneratorKey.self] = newValue }
    }
}
