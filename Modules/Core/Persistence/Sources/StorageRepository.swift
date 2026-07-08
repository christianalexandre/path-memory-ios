import Dependencies
import SharedModels

public protocol StorageRepository: Sendable {
    func bestScore(for difficulty: Difficulty) -> Int
    func save(_ result: GameResult)
    func recordMiss(at coordinate: Coordinate, difficulty: Difficulty)
}

private enum StorageRepositoryKey: DependencyKey {
    /// Shared instance so the best score survives across a session's runs.
    static let liveValue: any StorageRepository = InMemoryStorageRepository()
    /// Fresh per resolution for test isolation.
    static var testValue: any StorageRepository {
        InMemoryStorageRepository()
    }
}

public extension DependencyValues {
    var storageRepository: any StorageRepository {
        get { self[StorageRepositoryKey.self] }
        set { self[StorageRepositoryKey.self] = newValue }
    }
}
