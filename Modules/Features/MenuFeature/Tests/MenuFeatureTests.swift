import Testing
@testable import MenuFeature

@Test @MainActor func menuViewBuilds() {
    _ = MenuView(onPlay: { _ in })
}
