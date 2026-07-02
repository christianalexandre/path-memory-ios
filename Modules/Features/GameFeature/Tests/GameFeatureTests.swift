import Testing
@testable import GameFeature

@Test @MainActor func gameViewBuilds() {
    _ = GameView(onExit: {})
}
