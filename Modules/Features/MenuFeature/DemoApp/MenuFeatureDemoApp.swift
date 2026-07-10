import MenuFeature
import SwiftUI

@main
struct MenuFeatureDemoApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView(onPlay: { _ in })
                .preferredColorScheme(.dark)
        }
    }
}
