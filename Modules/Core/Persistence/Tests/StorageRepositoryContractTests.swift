import Foundation
import GRDB
import SharedModels
import Testing
@testable import Persistence

struct StorageFactory: CustomStringConvertible {
    let description: String
    let make: @Sendable () throws -> any StorageRepository
}

private let factories = [
    StorageFactory(description: "in-memory") { InMemoryStorageRepository() },
    StorageFactory(description: "GRDB") { try GRDBStorageRepository(writer: DatabaseQueue()) },
]

private func miss(
    at cell: Coordinate,
    difficulty: Difficulty,
    gridSize: Int = 5
) -> MissEvent {
    MissEvent(coordinate: cell, difficulty: difficulty, gridSize: gridSize, date: Date())
}

@Test(arguments: factories)
func bestScoreIsZeroWhenNothingSaved(_ factory: StorageFactory) throws {
    let store = try factory.make()
    #expect(store.bestScore(for: .normal) == 0)
}

@Test(arguments: factories)
func bestScoreReturnsHighestForThatDifficultyOnly(_ factory: StorageFactory) throws {
    let store = try factory.make()
    store.save(GameResult(score: 100, level: 3, difficulty: .normal))
    store.save(GameResult(score: 250, level: 5, difficulty: .normal))
    store.save(GameResult(score: 900, level: 8, difficulty: .hard))

    #expect(store.bestScore(for: .normal) == 250)
    #expect(store.bestScore(for: .hard) == 900)
    #expect(store.bestScore(for: .easy) == 0)
}

@Test(arguments: factories)
func savedResultsKeepInsertionOrder(_ factory: StorageFactory) throws {
    let store = try factory.make()
    store.save(GameResult(score: 10, level: 1, difficulty: .easy))
    store.save(GameResult(score: 20, level: 2, difficulty: .easy))

    #expect(store.savedResults.map(\.score) == [10, 20])
}

@Test(arguments: factories)
func missCountAccumulatesPerCellAndDifficulty(_ factory: StorageFactory) throws {
    let store = try factory.make()
    let cell = Coordinate(row: 2, column: 4)
    store.record(miss(at: cell, difficulty: .hard, gridSize: 5))
    store.record(miss(at: cell, difficulty: .hard, gridSize: 6))
    store.record(miss(at: cell, difficulty: .easy))

    #expect(store.missCount(at: cell, difficulty: .hard) == 2)
    #expect(store.missCount(at: cell, difficulty: .easy) == 1)
    #expect(store.missCount(at: Coordinate(row: 0, column: 0), difficulty: .hard) == 0)
}
