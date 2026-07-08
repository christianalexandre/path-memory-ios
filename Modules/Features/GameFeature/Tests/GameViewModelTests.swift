import Dependencies
import Foundation
import Persistence
import SharedModels
import Testing
@testable import GameFeature

private struct FixedPathGenerator: PathGenerator {
    let path: GamePath
    func generate(_: GameConfig) -> GamePath {
        path
    }
}

private let line = GamePath([
    Coordinate(row: 0, column: 0),
    Coordinate(row: 0, column: 1),
    Coordinate(row: 0, column: 2),
])

@MainActor
private func makeViewModel(
    path: GamePath = line,
    storage: InMemoryStorageRepository = InMemoryStorageRepository()
) -> GameViewModel {
    withDependencies {
        $0.continuousClock = ImmediateClock()
        $0.date = .constant(Date(timeIntervalSince1970: 0))
        $0.pathGenerator = FixedPathGenerator(path: path)
        $0.scoreEngine = StandardScoreEngine()
        $0.storageRepository = storage
        $0.hapticsService = NoopHapticsService()
    } operation: {
        GameViewModel(difficulty: .easy)
    }
}

@Test @MainActor func revealTransitionsToRecall() async {
    let viewModel = makeViewModel()
    viewModel.begin()
    #expect(viewModel.phase == .revealing)
    await viewModel.reveal()
    #expect(viewModel.phase == .recalling)
}

@Test @MainActor func revealHoldsForTheFullRevealDuration() async {
    // normal tier reveals for 2s; recall must not open early.
    let clock = TestClock()
    let viewModel = withDependencies {
        $0.continuousClock = clock
        $0.date = .constant(Date(timeIntervalSince1970: 0))
        $0.pathGenerator = FixedPathGenerator(path: line)
        $0.scoreEngine = StandardScoreEngine()
        $0.storageRepository = InMemoryStorageRepository()
        $0.hapticsService = NoopHapticsService()
    } operation: {
        GameViewModel(difficulty: .normal)
    }
    viewModel.begin()
    let reveal = Task { await viewModel.reveal() }
    await clock.advance(by: .seconds(1))
    #expect(viewModel.phase == .revealing)
    await clock.advance(by: .seconds(1))
    await reveal.value
    #expect(viewModel.phase == .recalling)
}

@Test @MainActor func tracingPathClearsPhaseAndScores() async {
    let viewModel = makeViewModel()
    viewModel.begin()
    await viewModel.reveal()
    for cell in line.coordinates {
        viewModel.handleTouch(cell)
    }
    #expect(viewModel.phase == .phaseCleared)
    #expect(viewModel.score > 0)
}

@Test @MainActor func pathCanBeTracedFromEitherEnd() async {
    let viewModel = makeViewModel()
    viewModel.begin()
    await viewModel.reveal()
    for cell in line.coordinates.reversed() {
        viewModel.handleTouch(cell)
    }
    #expect(viewModel.phase == .phaseCleared)
}

@Test @MainActor func clearingAdvancesResetsLivesAndKeepsScore() async {
    let viewModel = makeViewModel()
    viewModel.begin()
    await viewModel.reveal()
    for cell in line.coordinates {
        viewModel.handleTouch(cell)
    }
    let carried = viewModel.score
    await viewModel.advance()
    #expect(viewModel.phase == .revealing)
    #expect(viewModel.level == 2)
    #expect(viewModel.lives == 3)
    #expect(viewModel.score == carried)
}

@Test @MainActor func wrongCellCostsALifeRecordsMissAndResetsAttempt() async {
    let store = InMemoryStorageRepository()
    let viewModel = makeViewModel(storage: store)
    viewModel.begin()
    await viewModel.reveal()

    let miss = Coordinate(row: 3, column: 3)
    viewModel.handleTouch(miss)

    #expect(viewModel.lives == 2)
    #expect(viewModel.phase == .recalling)
    #expect(viewModel.activated.isEmpty)
    #expect(store.missCount(at: miss, difficulty: .easy) == 1)
}

@Test @MainActor func threeMissesEndTheGameAndPersistTheRun() async {
    let store = InMemoryStorageRepository()
    let viewModel = makeViewModel(storage: store)
    viewModel.begin()
    await viewModel.reveal()

    let miss = Coordinate(row: 3, column: 3)
    for _ in 0 ..< 3 {
        viewModel.handleTouch(miss)
    }

    #expect(viewModel.phase == .gameOver)
    #expect(store.savedResults.count == 1)
    #expect(store.savedResults.first?.difficulty == .easy)
}

@Test @MainActor func retryStartsAFreshRun() async {
    let viewModel = makeViewModel()
    viewModel.begin()
    await viewModel.reveal()
    for _ in 0 ..< 3 {
        viewModel.handleTouch(Coordinate(row: 3, column: 3))
    }
    #expect(viewModel.phase == .gameOver)

    viewModel.retry()
    #expect(viewModel.phase == .revealing)
    #expect(viewModel.level == 1)
    #expect(viewModel.lives == 3)
    #expect(viewModel.score == 0)
}
