import Dependencies
import Observation
import Persistence
import SharedModels

@MainActor
@Observable
public final class MenuViewModel {
    public var difficulty: Difficulty = .normal {
        didSet { refreshBestScore() }
    }

    public private(set) var bestScore = 0
    @ObservationIgnored @Dependency(\.storageRepository) private var storage

    public init() {
        refreshBestScore()
    }

    private func refreshBestScore() {
        bestScore = storage.bestScore(for: difficulty)
    }
}
