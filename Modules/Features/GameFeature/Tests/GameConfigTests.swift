import SharedModels
import Testing
@testable import GameFeature

@Test func firstPhaseIsFiveByFive() {
    let config = GameConfig(difficulty: .normal, phaseIndex: 1)
    #expect(config.gridSize == 5)
}

@Test func gridGrowsWithProgressUpToTheCap() {
    #expect(GameConfig(difficulty: .easy, phaseIndex: 3).gridSize == 7)
    #expect(GameConfig(difficulty: .easy, phaseIndex: 6).gridSize == 10)
    #expect(GameConfig(difficulty: .easy, phaseIndex: 50).gridSize == 10)
}

@Test func gridCapIsConfigurable() {
    #expect(GameConfig(difficulty: .easy, phaseIndex: 50, gridCap: 15).gridSize == 15)
}

@Test func densityDrivesPathLengthAndIsClamped() {
    // phase 1: density 0.33, grid 5 -> round(25 * 0.33) = 8
    #expect(GameConfig(difficulty: .normal, phaseIndex: 1).pathLength == 8)
    // deep phase: density clamps at 0.9, grid 10 -> round(100 * 0.9) = 90
    #expect(GameConfig(difficulty: .normal, phaseIndex: 50).pathLength == 90)
}

@Test func phaseIndexIsClampedToAtLeastOne() {
    #expect(GameConfig(difficulty: .normal, phaseIndex: 0).phaseIndex == 1)
}

@Test func tierDrivesRevealTimeAndMultiplier() {
    #expect(GameConfig(difficulty: .easy, phaseIndex: 1).revealDuration == .seconds(3))
    #expect(GameConfig(difficulty: .normal, phaseIndex: 1).revealDuration == .seconds(2))
    #expect(GameConfig(difficulty: .hard, phaseIndex: 1).revealDuration == .seconds(1))

    #expect(GameConfig(difficulty: .easy, phaseIndex: 1).scoreMultiplier == 1)
    #expect(GameConfig(difficulty: .normal, phaseIndex: 1).scoreMultiplier == 2)
    #expect(GameConfig(difficulty: .hard, phaseIndex: 1).scoreMultiplier == 3)
}
