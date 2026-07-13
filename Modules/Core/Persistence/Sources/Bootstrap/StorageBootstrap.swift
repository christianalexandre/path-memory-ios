import Dependencies
import OSLog

public enum StorageBootstrap {
    public static func makeLive() -> any StorageRepository {
        do {
            return try GRDBStorageRepository.onDisk()
        } catch {
            Logger.persistence.error(
                "Falling back to in-memory storage: \(String(describing: error), privacy: .public)"
            )
            return InMemoryStorageRepository()
        }
    }

    /// Call once at launch, before any feature reads `\.storageRepository`.
    public static func install(_ repository: any StorageRepository) {
        prepareDependencies { $0.storageRepository = repository }
    }
}
