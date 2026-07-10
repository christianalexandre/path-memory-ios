#if canImport(UIKit)
    import Dependencies
    import MenuFeature
    import Persistence
    import SnapshotSupport
    import SnapshotTesting
    import SwiftUI
    import Testing

    @MainActor
    struct MenuSnapshotTests {
        @Test func menu() {
            withDependencies {
                $0.storageRepository = InMemoryStorageRepository()
            } operation: {
                assertSnapshot(of: MenuView(onPlay: { _ in }), as: Snap.device())
            }
        }
    }
#endif
