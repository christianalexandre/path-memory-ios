import GameFeature
import MenuFeature
import SwiftUI

struct RootView: View {
    private enum Screen {
        case menu
        case game
    }

    @State private var screen: Screen = .menu

    var body: some View {
        switch screen {
        case .menu:
            MenuView(onPlay: { screen = .game })
        case .game:
            GameView(onExit: { screen = .menu })
        }
    }
}
