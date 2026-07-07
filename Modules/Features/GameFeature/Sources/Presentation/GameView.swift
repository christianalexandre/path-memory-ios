import SwiftUI
import UIComponents

/// Static mockup of the in-round screen; the live game loop arrives with the ViewModel.
@MainActor
public struct GameView: View {
    private static let path = [
        GridPoint(0, 2), GridPoint(2, 2), GridPoint(2, 0), GridPoint(4, 0),
        GridPoint(4, 3), GridPoint(1, 3), GridPoint(1, 5), GridPoint(5, 5),
    ]

    private let onExit: () -> Void

    public init(onExit: @escaping () -> Void) {
        self.onExit = onExit
    }

    public var body: some View {
        ZStack {
            NeonBackground()
            VStack(spacing: 0) {
                closeRow
                HUDView(score: 1240, level: 7, lives: 3)
                    .padding(.top, 14)
                PhaseBanner(Text("Memorize!", bundle: .module))
                    .padding(.top, 24)
                Spacer()
                GridView(configuration: configuration)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 6)
                Spacer()
                Text("Path · 8 dots", bundle: .module)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .textCase(.uppercase)
                    .kerning(1.4)
                    .foregroundStyle(PMTheme.textFaint)
            }
            .padding(.horizontal, 26)
            .padding(.top, 10)
            .padding(.bottom, 22)
        }
    }

    private var configuration: GridConfiguration {
        var config = GridConfiguration(dotsPerSide: 6)
        config.litDots = Set(Self.path)
        config.trail = Self.path
        return config
    }

    private var closeRow: some View {
        HStack {
            Button(action: onExit) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(PMTheme.textSecondary)
                    .frame(width: 34, height: 34)
                    .background(Color.white.opacity(0.04), in: Circle())
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.09), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Close", bundle: .module))
            Spacer()
        }
    }
}

#Preview {
    GameView(onExit: {})
}
