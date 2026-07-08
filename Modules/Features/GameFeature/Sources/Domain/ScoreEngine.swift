import Dependencies
import Foundation

public protocol ScoreEngine: Sendable {
    func score(for path: GamePath, config: GameConfig, livesRemaining: Int, elapsed: Duration) -> Int
}

/// Path work scaled by difficulty and progress, plus bonuses for spare lives and
/// speed. Constants match `game-rules.md` and are easy to retune.
public struct StandardScoreEngine: ScoreEngine {
    public init() {}

    public func score(for path: GamePath, config: GameConfig, livesRemaining: Int, elapsed: Duration) -> Int {
        let pathLength = Double(path.length)
        let base = pathLength * 10 * config.scoreMultiplier * (1 + Double(config.phaseIndex) * 0.1)
        let livesBonus = Double(livesRemaining) * 25
        let parSeconds = pathLength * 0.4
        let timeBonus = max(0, parSeconds - elapsed.seconds) * 5
        return Int((base + livesBonus + timeBonus).rounded())
    }
}

private enum ScoreEngineKey: DependencyKey {
    static let liveValue: any ScoreEngine = StandardScoreEngine()
}

public extension DependencyValues {
    var scoreEngine: any ScoreEngine {
        get { self[ScoreEngineKey.self] }
        set { self[ScoreEngineKey.self] = newValue }
    }
}
