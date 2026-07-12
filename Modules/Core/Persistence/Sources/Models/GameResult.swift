import Foundation
import SharedModels

public struct GameResult: Equatable, Sendable {
    public let score: Int
    public let level: Int
    public let difficulty: Difficulty
    public let date: Date

    public init(score: Int, level: Int, difficulty: Difficulty, date: Date = Date()) {
        self.score = score
        self.level = level
        self.difficulty = difficulty
        self.date = date
    }
}
