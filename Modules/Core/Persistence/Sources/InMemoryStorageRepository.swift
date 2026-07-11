import Foundation
import SharedModels

public final class InMemoryStorageRepository: StorageRepository, @unchecked Sendable {
    private let lock = NSLock()
    private var results: [GameResult] = []
    private var misses: [MissEvent] = []

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

    public func record(_ miss: MissEvent) {
        lock.withLock { misses.append(miss) }
    }

    public var savedResults: [GameResult] {
        lock.withLock { results }
    }

    public func missCount(at coordinate: Coordinate, difficulty: Difficulty) -> Int {
        lock.withLock {
            misses
                .count(where: { $0.coordinate == coordinate && $0.difficulty == difficulty })
        }
    }
}
