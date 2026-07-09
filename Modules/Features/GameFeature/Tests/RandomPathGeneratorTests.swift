import SharedModels
import Testing
@testable import GameFeature

/// Deterministic SplitMix64 so path assertions are reproducible.
private struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &+ 0x9E37_79B9_7F4A_7C15
        var mixed = state
        mixed = (mixed ^ (mixed >> 30)) &* 0xBF58_476D_1CE4_E5B9
        mixed = (mixed ^ (mixed >> 27)) &* 0x94D0_49BB_1331_11EB
        return mixed ^ (mixed >> 31)
    }
}

@Test func randomPathIsValidAcrossManySeeds() {
    let config = GameConfig(difficulty: .normal, phaseIndex: 3)
    for seed in UInt64(1) ... 60 {
        var rng = SeededRNG(seed: seed)
        let path = RandomPathGenerator.generate(config, using: &rng)

        #expect(path.length == config.pathLength)
        #expect(Set(path.coordinates).count == path.length) // no repeated cell

        for (previous, next) in zip(path.coordinates, path.coordinates.dropFirst()) {
            let step = abs(previous.row - next.row) + abs(previous.column - next.column)
            #expect(step == 1) // orthogonal, connected
        }
        for cell in path.coordinates {
            #expect(cell.row >= 0 && cell.row < config.gridSize)
            #expect(cell.column >= 0 && cell.column < config.gridSize)
        }
    }
}

@Test func randomPathVariesAcrossSeeds() {
    let config = GameConfig(difficulty: .normal, phaseIndex: 3)
    var first = SeededRNG(seed: 1)
    var second = SeededRNG(seed: 99)
    #expect(RandomPathGenerator.generate(config, using: &first)
        != RandomPathGenerator.generate(config, using: &second))
}
