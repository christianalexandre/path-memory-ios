import SwiftUI

@MainActor
public struct MenuView: View {
    private let onPlay: () -> Void

    public init(onPlay: @escaping () -> Void) {
        self.onPlay = onPlay
    }

    public var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(verbatim: "Path Memory")
                .font(.largeTitle.bold())
            Spacer()
            Button(action: onPlay) {
                Text("Play", bundle: .module)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MenuView(onPlay: {})
}
