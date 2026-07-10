import Foundation
import GRDB
import OSLog
import SharedModels

public final class GRDBStorageRepository: StorageRepository, Sendable {
    private let writer: any DatabaseWriter

    public init(writer: any DatabaseWriter) throws {
        self.writer = writer
        try Self.migrator.migrate(writer)
    }

    public static func onDisk(directory: URL? = nil) throws -> GRDBStorageRepository {
        let folder = try directory ?? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("PathMemory", isDirectory: true)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let queue = try DatabaseQueue(path: folder.appendingPathComponent("pathmemory.sqlite").path)
        return try GRDBStorageRepository(writer: queue)
    }

    public func bestScore(for difficulty: Difficulty) -> Int {
        read(default: 0) { db in
            try GameResultRecord
                .filter(GameResultRecord.Columns.difficulty == difficulty.rawValue)
                .select(max(GameResultRecord.Columns.score), as: Int.self)
                .fetchOne(db) ?? 0
        }
    }

    public func save(_ result: GameResult) {
        asyncWrite { db in
            try GameResultRecord(result).insert(db)
        }
    }

    public func record(_ miss: MissEvent) {
        asyncWrite { db in
            try MissEventRecord(miss).insert(db)
        }
    }

    public var savedResults: [GameResult] {
        read(default: []) { db in
            try GameResultRecord.order(GameResultRecord.Columns.id).fetchAll(db)
        }
        .compactMap(\.gameResult)
    }

    public func missCount(at coordinate: Coordinate, difficulty: Difficulty) -> Int {
        read(default: 0) { db in
            try MissEventRecord
                .filter(MissEventRecord.Columns.difficulty == difficulty.rawValue)
                .filter(MissEventRecord.Columns.row == coordinate.row)
                .filter(MissEventRecord.Columns.col == coordinate.column)
                .fetchCount(db)
        }
    }

    private func read<Value: Sendable>(
        default fallback: Value,
        _ value: @Sendable (Database) throws -> Value
    ) -> Value {
        do {
            return try writer.read(value)
        } catch {
            Logger.persistence.error(
                "Storage read failed: \(String(describing: error), privacy: .public)"
            )
            return fallback
        }
    }

    /// DatabaseQueue serializes accesses, so a later read still observes this
    /// write even though it never blocks the caller.
    private func asyncWrite(_ updates: @escaping @Sendable (Database) throws -> Void) {
        writer.asyncWrite(updates) { _, result in
            if case let .failure(error) = result {
                Logger.persistence.error(
                    "Storage write failed: \(String(describing: error), privacy: .public)"
                )
            }
        }
    }

    private static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        #if DEBUG
            // Pre-launch only: recreate the DB instead of hand-writing throwaway
            // migrations while the schema still churns. Remove before shipping.
            migrator.eraseDatabaseOnSchemaChange = true
        #endif
        migrator.registerMigration("v1-gameResult-missEvent") { db in
            try db.create(table: "gameResult") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("score", .integer).notNull()
                table.column("level", .integer).notNull()
                table.column("difficulty", .text).notNull().indexed()
                table.column("date", .double).notNull()
            }
            try db.create(table: "missEvent") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("difficulty", .text).notNull()
                table.column("row", .integer).notNull()
                table.column("col", .integer).notNull()
                table.column("gridSize", .integer).notNull()
                table.column("date", .double).notNull()
            }
            try db.create(indexOn: "missEvent", columns: ["difficulty", "row", "col"])
        }
        return migrator
    }
}

// Dates are stored as reference-date seconds so they round-trip bit-exact;
// GRDB's default datetime text truncates to milliseconds.

private struct GameResultRecord: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "gameResult"

    enum Columns {
        static let id = Column("id")
        static let score = Column("score")
        static let difficulty = Column("difficulty")
    }

    var score: Int
    var level: Int
    var difficulty: String
    var date: Double

    init(_ result: GameResult) {
        score = result.score
        level = result.level
        difficulty = result.difficulty.rawValue
        date = result.date.timeIntervalSinceReferenceDate
    }

    var gameResult: GameResult? {
        Difficulty(rawValue: difficulty).map {
            GameResult(
                score: score,
                level: level,
                difficulty: $0,
                date: Date(timeIntervalSinceReferenceDate: date)
            )
        }
    }
}

private struct MissEventRecord: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "missEvent"

    enum Columns {
        static let difficulty = Column("difficulty")
        static let row = Column("row")
        static let col = Column("col")
    }

    var difficulty: String
    var row: Int
    var col: Int
    var gridSize: Int
    var date: Double

    init(_ miss: MissEvent) {
        difficulty = miss.difficulty.rawValue
        row = miss.coordinate.row
        col = miss.coordinate.column
        gridSize = miss.gridSize
        date = miss.date.timeIntervalSinceReferenceDate
    }
}
