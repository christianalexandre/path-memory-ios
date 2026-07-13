import Dependencies
import OSLog
import SharedModels

public protocol StorageRepository: Sendable {
    func bestScore(for difficulty: Difficulty) -> Int
    func save(_ result: GameResult)
    func record(_ miss: MissEvent)
    var savedResults: [GameResult] { get }
    func missCount(at coordinate: Coordinate, difficulty: Difficulty) -> Int
}

extension Logger {
    static let persistence = Logger(
        subsystem: "com.christianalexandre.PathMemory",
        category: "Persistence"
    )
}

private enum StorageRepositoryKey: DependencyKey {
    /// Lazy fallback for contexts without the launch bootstrap (demos, previews).
    static let liveValue: any StorageRepository = StorageBootstrap.makeLive()

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
