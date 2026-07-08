import Testing
@testable import SharedModels

@Test func difficultyExposesThreeTiersInOrder() {
    #expect(Difficulty.allCases == [.easy, .normal, .hard])
}

@Test func difficultyRawValuesAreStableForPersistence() {
    #expect(Difficulty.easy.rawValue == "easy")
    #expect(Difficulty.normal.rawValue == "normal")
    #expect(Difficulty.hard.rawValue == "hard")
    #expect(Difficulty(rawValue: "hard") == .hard)
}
