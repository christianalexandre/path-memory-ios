import Foundation
import SharedModels

public struct MissEvent: Equatable, Sendable {
    public let coordinate: Coordinate
    public let difficulty: Difficulty
    public let gridSize: Int
    public let date: Date

    public init(coordinate: Coordinate, difficulty: Difficulty, gridSize: Int, date: Date) {
        self.coordinate = coordinate
        self.difficulty = difficulty
        self.gridSize = gridSize
        self.date = date
    }
}
