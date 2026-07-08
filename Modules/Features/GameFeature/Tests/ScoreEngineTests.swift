import SharedModels
import Testing
@testable import GameFeature

private func makePath(length: Int) -> GamePath {
    GamePath((0 ..< length).map { Coordinate(row: 0, column: $0) })
}

@Test func perfectFastRunAddsBaseLivesAndTimeBonus() {
    // normal (mult 2), phase 1, path 8, 3 lives, instant finish.
    // base 8*10*2*1.1 = 176, lives 3*25 = 75, time (3.2-0)*5 = 16 -> 267
    let config = GameConfig(difficulty: .normal, phaseIndex: 1)
    let score = StandardScoreEngine().score(
        for: makePath(length: 8),
        config: config,
        livesRemaining: 3,
        elapsed: .zero
    )
    #expect(score == 267)
}

@Test func slowFinishDropsTheTimeBonusToZero() {
    // Same run but well over par time (3.2s) -> base 176 + lives 75 = 251
    let config = GameConfig(difficulty: .normal, phaseIndex: 1)
    let score = StandardScoreEngine().score(
        for: makePath(length: 8),
        config: config,
        livesRemaining: 3,
        elapsed: .seconds(10)
    )
    #expect(score == 251)
}
