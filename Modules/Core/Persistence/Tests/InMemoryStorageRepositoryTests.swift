import SharedModels
import Testing
@testable import Persistence

@Test func bestScoreIsZeroWhenNothingSaved() {
    let store = InMemoryStorageRepository()
    #expect(store.bestScore(for: .normal) == 0)
}

@Test func bestScoreReturnsHighestForThatDifficultyOnly() {
    let store = InMemoryStorageRepository()
    store.save(GameResult(score: 100, level: 3, difficulty: .normal))
    store.save(GameResult(score: 250, level: 5, difficulty: .normal))
    store.save(GameResult(score: 900, level: 8, difficulty: .hard))

    #expect(store.bestScore(for: .normal) == 250)
    #expect(store.bestScore(for: .hard) == 900)
    #expect(store.bestScore(for: .easy) == 0)
}

@Test func savedResultsKeepInsertionOrder() {
    let store = InMemoryStorageRepository()
    store.save(GameResult(score: 10, level: 1, difficulty: .easy))
    store.save(GameResult(score: 20, level: 2, difficulty: .easy))

    #expect(store.savedResults.map(\.score) == [10, 20])
}

@Test func recordMissAccumulatesPerCellAndDifficulty() {
    let store = InMemoryStorageRepository()
    let cell = Coordinate(row: 2, column: 4)
    store.recordMiss(at: cell, difficulty: .hard)
    store.recordMiss(at: cell, difficulty: .hard)
    store.recordMiss(at: cell, difficulty: .easy)

    #expect(store.missCount(at: cell, difficulty: .hard) == 2)
    #expect(store.missCount(at: cell, difficulty: .easy) == 1)
    #expect(store.missCount(at: Coordinate(row: 0, column: 0), difficulty: .hard) == 0)
}
