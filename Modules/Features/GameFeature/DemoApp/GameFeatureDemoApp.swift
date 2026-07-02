import GameFeature
import SwiftUI

@main
struct GameFeatureDemoApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(onExit: {})
        }
    }
}
