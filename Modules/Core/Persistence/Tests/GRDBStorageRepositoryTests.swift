import Foundation
import GRDB
import SharedModels
import Testing
@testable import Persistence

@Test func fieldsSurviveTheDatabaseRoundTripExactly() throws {
    let store = try GRDBStorageRepository(writer: DatabaseQueue())
    let played = Date()
    store.save(GameResult(score: 10, level: 1, difficulty: .easy, date: played))
    store.save(GameResult(score: 20, level: 2, difficulty: .hard, date: played))

    #expect(store.savedResults == [
        GameResult(score: 10, level: 1, difficulty: .easy, date: played),
        GameResult(score: 20, level: 2, difficulty: .hard, date: played),
    ])
}

@Test func dataSurvivesReopeningTheDatabase() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }

    let first = try GRDBStorageRepository.onDisk(directory: directory)
    first.save(GameResult(score: 300, level: 4, difficulty: .normal))
    first.record(MissEvent(
        coordinate: Coordinate(row: 1, column: 1),
        difficulty: .normal,
        gridSize: 5,
        date: Date()
    ))
    // Writes are async; this read is a barrier before the second connection
    // opens the same file.
    #expect(first.savedResults.count == 1)

    let second = try GRDBStorageRepository.onDisk(directory: directory)
    #expect(second.bestScore(for: .normal) == 300)
    #expect(second.missCount(at: Coordinate(row: 1, column: 1), difficulty: .normal) == 1)
}
