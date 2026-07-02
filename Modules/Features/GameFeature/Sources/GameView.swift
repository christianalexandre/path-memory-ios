import SwiftUI

@MainActor
public struct GameView: View {
    private let onExit: () -> Void

    public init(onExit: @escaping () -> Void) {
        self.onExit = onExit
    }

    public var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Game", bundle: .module)
                .font(.largeTitle.bold())
            Spacer()
            Button(action: onExit) {
                Text("Back", bundle: .module)
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    GameView(onExit: {})
}
