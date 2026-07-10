#if canImport(UIKit)
    import Dependencies
    import Foundation
    import Persistence
    import SnapshotSupport
    import SnapshotTesting
    import SwiftUI
    import Testing
    import UIComponents
    @testable import GameFeature

    @MainActor
    struct GameSnapshotTests {
        @Test func reveal() async {
            let viewModel = await drivenViewModel { $0.begin() }
            assertSnapshot(of: GameView(viewModel: viewModel, onExit: {}), as: Snap.device())
        }

        @Test func recall() async {
            let viewModel = await drivenViewModel { model in
                model.begin()
                await model.reveal()
                for coordinate in model.path.coordinates.prefix(3) {
                    model.handleTouch(coordinate)
                }
            }
            assertSnapshot(of: GameView(viewModel: viewModel, onExit: {}), as: Snap.device())
        }

        @Test func resultGameOver() {
            var review = GridConfiguration(dotsPerSide: 5)
            let path = [GridPoint(0, 0), GridPoint(0, 1), GridPoint(1, 1), GridPoint(2, 1)]
            review.ghostDots = Set(path)
            review.ghostTrail = path
            review.correctDots = [GridPoint(0, 0), GridPoint(0, 1)]
            review.userTrail = [GridPoint(0, 0), GridPoint(0, 1)]
            review.userTrailColor = PMTheme.success
            review.wrongDots = [GridPoint(1, 0)]
            assertSnapshot(
                of: ResultView(score: 1240, best: 2600, review: review, onRetry: {}, onMenu: {}),
                as: Snap.device()
            )
        }

        /// Stub clock/date so the reveal→recall transition resolves synchronously.
        private func drivenViewModel(_ drive: @MainActor (GameViewModel) async -> Void) async -> GameViewModel {
            await withDependencies {
                $0.continuousClock = ImmediateClock()
                $0.date = .constant(Date(timeIntervalSince1970: 0))
            } operation: {
                let model = GameViewModel(difficulty: .normal)
                await drive(model)
                return model
            }
        }
    }
#endif
