import Foundation
import SharedModels

public final class InMemoryStorageRepository: StorageRepository, @unchecked Sendable {
    private let lock = NSLock()
    private var results: [GameResult] = []
    private var misses: [Difficulty: [Coordinate: Int]] = [:]

    public init() {}

    public func bestScore(for difficulty: Difficulty) -> Int {
        lock.withLock {
            results
                .filter { $0.difficulty == difficulty }
                .map(\.score)
                .max() ?? 0
        }
    }

    public func save(_ result: GameResult) {
        lock.withLock { results.append(result) }
    }

    public func recordMiss(at coordinate: Coordinate, difficulty: Difficulty) {
        lock.withLock { misses[difficulty, default: [:]][coordinate, default: 0] += 1 }
    }

    public var savedResults: [GameResult] {
        lock.withLock { results }
    }

    public func missCount(at coordinate: Coordinate, difficulty: Difficulty) -> Int {
        lock.withLock { misses[difficulty]?[coordinate] ?? 0 }
    }
}
