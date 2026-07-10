import SharedModels
import Testing
@testable import GameFeature

@Test func generatedPathHasTheConfiguredLength() {
    let config = GameConfig(difficulty: .normal, phaseIndex: 1)
    #expect(StubPathGenerator().generate(config).length == config.pathLength)
}

@Test func generatedPathIsOrthogonalConnectedAndNonCrossing() {
    let config = GameConfig(difficulty: .hard, phaseIndex: 4)
    let path = StubPathGenerator().generate(config)

    #expect(Set(path.coordinates).count == path.length)

    for (previous, next) in zip(path.coordinates, path.coordinates.dropFirst()) {
        let step = abs(previous.row - next.row) + abs(previous.column - next.column)
        #expect(step == 1)
    }
}

@Test func generatedPathStaysInsideTheGrid() {
    let config = GameConfig(difficulty: .easy, phaseIndex: 6)
    for cell in StubPathGenerator().generate(config).coordinates {
        #expect(cell.row >= 0 && cell.row < config.gridSize)
        #expect(cell.column >= 0 && cell.column < config.gridSize)
    }
}
