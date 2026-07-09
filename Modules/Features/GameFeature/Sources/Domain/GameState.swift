import SharedModels

public enum GamePhase: Equatable, Sendable {
    case idle
    case revealing
    case recalling
    case phaseCleared
    case gameOver
}

public struct RunReview: Equatable, Sendable {
    public let path: [Coordinate]
    public let trace: [Coordinate]
    public let wrong: Coordinate

    public init(path: [Coordinate], trace: [Coordinate], wrong: Coordinate) {
        self.path = path
        self.trace = trace
        self.wrong = wrong
    }
}
