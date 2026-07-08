import Foundation
import SharedModels

/// Per-phase parameters from the separate levers: difficulty tier (reveal time,
/// score multiplier) and progress (grid size, path density). Obstacles come later.
public struct GameConfig: Equatable, Sendable {
    /// Playable cap on a phone; configurable to test bigger grids.
    public static let defaultGridCap = 10

    public let difficulty: Difficulty
    public let phaseIndex: Int
    public let gridSize: Int
    public let pathLength: Int
    public let revealDuration: Duration
    public let scoreMultiplier: Double

    public init(difficulty: Difficulty, phaseIndex: Int, gridCap: Int = defaultGridCap) {
        let phase = max(phaseIndex, 1)
        let size = min(4 + phase, gridCap)
        let density = min(max(0.3 + Double(phase) * 0.03, 0.3), 0.9)
        let cells = size * size

        self.difficulty = difficulty
        self.phaseIndex = phase
        gridSize = size
        pathLength = min(max(Int((Double(cells) * density).rounded()), 2), cells)
        revealDuration = Self.revealDuration(for: difficulty)
        scoreMultiplier = Self.scoreMultiplier(for: difficulty)
    }

    private static func revealDuration(for difficulty: Difficulty) -> Duration {
        switch difficulty {
        case .easy: .seconds(3)
        case .normal: .seconds(2)
        case .hard: .seconds(1)
        }
    }

    private static func scoreMultiplier(for difficulty: Difficulty) -> Double {
        switch difficulty {
        case .easy: 1
        case .normal: 2
        case .hard: 3
        }
    }
}
