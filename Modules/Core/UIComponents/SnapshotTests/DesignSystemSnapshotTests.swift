#if canImport(UIKit)
    import SnapshotSupport
    import SnapshotTesting
    import SwiftUI
    import Testing
    import UIComponents

    @MainActor
    struct DesignSystemSnapshotTests {
        @Test func dotStates() {
            let states: [DotState] = [.idle, .lit, .finger, .correct, .wrong, .ghost]
            let view = HStack(spacing: 20) {
                ForEach(Array(states.enumerated()), id: \.offset) { _, state in
                    DotView(state: state, diameter: 36)
                }
            }
            .padding(28)
            .background(PMTheme.base)
            assertSnapshot(of: view, as: Snap.sized(CGSize(width: 400, height: 92)))
        }

        @Test func wordmark() {
            let view = PMWordmark()
                .padding(40)
                .background(PMTheme.base)
            assertSnapshot(of: view, as: Snap.sized(CGSize(width: 300, height: 200)))
        }

        @Test func hud() {
            let view = HUDView(score: 1280, level: 4, lives: 2, timerProgress: 0.6, isTimerActive: true)
                .padding(24)
                .frame(width: 380)
                .background(PMTheme.base)
            assertSnapshot(of: view, as: Snap.sized(CGSize(width: 380, height: 120)))
        }

        @Test func phaseBanners() {
            let view = VStack(spacing: 16) {
                PhaseBanner(Text(verbatim: "Memorize!"))
                PhaseBanner(Text(verbatim: "Perfect!"), tone: .success)
                PhaseBanner(Text(verbatim: "Missed"), tone: .danger)
            }
            .padding(28)
            .background(PMTheme.base)
            assertSnapshot(of: view, as: Snap.sized(CGSize(width: 320, height: 220)))
        }

        @Test func gridRevealBoard() {
            var config = GridConfiguration(dotsPerSide: 5)
            let path = [GridPoint(0, 1), GridPoint(1, 1), GridPoint(1, 2), GridPoint(2, 2), GridPoint(2, 3)]
            config.litDots = Set(path)
            config.trail = path
            assertSnapshot(of: board(config), as: Snap.sized(CGSize(width: 300, height: 300)))
        }

        @Test func gridRecallBoard() {
            var config = GridConfiguration(dotsPerSide: 5)
            let traced = [GridPoint(0, 1), GridPoint(1, 1), GridPoint(1, 2)]
            config.correctDots = Set(traced)
            config.userTrail = traced
            config.userTrailColor = PMTheme.success
            config.fingerDot = GridPoint(1, 2)
            assertSnapshot(of: board(config), as: Snap.sized(CGSize(width: 300, height: 300)))
        }

        private func board(_ config: GridConfiguration) -> some View {
            GridView(configuration: config)
                .aspectRatio(1, contentMode: .fit)
                .padding(20)
                .background(PMTheme.base)
        }
    }
#endif
