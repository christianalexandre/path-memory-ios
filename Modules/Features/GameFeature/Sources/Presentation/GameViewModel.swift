import Dependencies
import Foundation
import Observation
import Persistence
import SharedModels

/// Owns the phase machine and run state; kept UI-agnostic so it is host-testable.
@MainActor
@Observable
public final class GameViewModel {
    static let maxLives = 3

    public let difficulty: Difficulty

    public private(set) var phase: GamePhase = .idle
    public private(set) var score = 0
    public private(set) var level = 1
    public private(set) var lives = maxLives
    public private(set) var path = GamePath([])
    public private(set) var activated: [Coordinate] = []
    public private(set) var fingerCell: Coordinate?
    public private(set) var wrongCell: Coordinate?
    public private(set) var finalScore = 0
    public private(set) var review: RunReview?
    public private(set) var bestScore = 0

    public var gridSize: Int {
        config.gridSize
    }

    @ObservationIgnored @Dependency(\.pathGenerator) private var pathGenerator
    @ObservationIgnored @Dependency(\.scoreEngine) private var scoreEngine
    @ObservationIgnored @Dependency(\.storageRepository) private var storage
    @ObservationIgnored @Dependency(\.hapticsService) private var haptics
    @ObservationIgnored @Dependency(\.continuousClock) private var clock
    @ObservationIgnored @Dependency(\.date) private var date

    private let gridCap: Int
    private var config: GameConfig
    private var expected: [Coordinate] = []
    private var recallStart: Date?

    public init(difficulty: Difficulty, gridCap: Int = GameConfig.defaultGridCap) {
        self.difficulty = difficulty
        self.gridCap = gridCap
        config = GameConfig(difficulty: difficulty, phaseIndex: 1, gridCap: gridCap)
    }

    public func begin() {
        guard phase == .idle else { return }
        score = 0
        level = 1
        lives = Self.maxLives
        review = nil
        bestScore = storage.bestScore(for: difficulty)
        configurePhase()
        phase = .revealing
    }

    public func reveal() async {
        guard phase == .revealing else { return }
        do {
            try await clock.sleep(for: config.revealDuration)
        } catch {
            return
        }
        guard phase == .revealing else { return }
        recallStart = date.now
        phase = .recalling
    }

    public func advance() async {
        guard phase == .phaseCleared else { return }
        do {
            try await clock.sleep(for: .milliseconds(900))
        } catch {
            return
        }
        guard phase == .phaseCleared else { return }
        level += 1
        lives = Self.maxLives
        configurePhase()
        phase = .revealing
    }

    public func retry() {
        phase = .idle
        begin()
    }

    public func handleTouch(_ coordinate: Coordinate) {
        guard phase == .recalling else { return }
        guard wrongCell == nil else { return }
        if activated.contains(coordinate) {
            fingerCell = coordinate
            return
        }
        if expected.isEmpty {
            guard let sequence = path.sequence(startingAt: coordinate) else {
                registerMiss(at: coordinate)
                return
            }
            expected = sequence
        }
        let nextIndex = activated.count
        if nextIndex < expected.count, expected[nextIndex] == coordinate {
            activated.append(coordinate)
            fingerCell = coordinate
            wrongCell = nil
            haptics.success()
            if activated.count == expected.count {
                clearPhase()
            }
            return
        }
        if let last = activated.last, isAdjacent(coordinate, last) {
            registerMiss(at: coordinate)
        }
    }

    public func endTouch() {
        fingerCell = nil
        wrongCell = nil
    }

    private func isAdjacent(_ lhs: Coordinate, _ rhs: Coordinate) -> Bool {
        abs(lhs.row - rhs.row) + abs(lhs.column - rhs.column) == 1
    }

    private func configurePhase() {
        config = GameConfig(difficulty: difficulty, phaseIndex: level, gridCap: gridCap)
        path = pathGenerator.generate(config)
        activated = []
        expected = []
        fingerCell = nil
        wrongCell = nil
        recallStart = nil
    }

    private func registerMiss(at coordinate: Coordinate) {
        wrongCell = coordinate
        lives -= 1
        storage.record(MissEvent(
            coordinate: coordinate,
            difficulty: difficulty,
            gridSize: config.gridSize,
            date: date.now
        ))
        haptics.failure()
        if lives <= 0 {
            endGame(wrong: coordinate)
            return
        }
        activated = []
        expected = []
        fingerCell = nil
    }

    private func clearPhase() {
        let elapsed = recallStart.map { Duration.seconds(date.now.timeIntervalSince($0)) } ?? .zero
        score += scoreEngine.score(for: path, config: config, livesRemaining: lives, elapsed: elapsed)
        fingerCell = nil
        haptics.success()
        phase = .phaseCleared
    }

    private func endGame(wrong: Coordinate) {
        review = RunReview(path: path.coordinates, trace: activated, wrong: wrong)
        finalScore = score
        storage.save(GameResult(score: score, level: level, difficulty: difficulty, date: date.now))
        bestScore = max(bestScore, finalScore)
        activated = []
        expected = []
        fingerCell = nil
        phase = .gameOver
    }
}
