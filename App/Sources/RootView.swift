import GameFeature
import MenuFeature
import SwiftUI

struct RootView: View {
    private enum Screen {
        case menu
        case game(Difficulty)
    }

    @State private var screen: Screen = .menu

    var body: some View {
        Group {
            switch screen {
            case .menu:
                MenuView(onPlay: { screen = .game($0) })
            case let .game(difficulty):
                GameView(difficulty: difficulty, onExit: { screen = .menu })
            }
        }
        .preferredColorScheme(.dark)
    }
}
