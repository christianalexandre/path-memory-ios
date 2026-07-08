import SwiftUI
import UIComponents

@MainActor
struct ResultView: View {
    let score: Int
    let best: Int
    let onRetry: () -> Void
    let onMenu: () -> Void

    var body: some View {
        ZStack {
            NeonBackground()
            VStack(spacing: 0) {
                Spacer()
                PhaseBanner(Text("Game Over", bundle: .module), tone: .danger)
                scoreBlock
                    .padding(.top, 30)
                Spacer()
                VStack(spacing: 14) {
                    Button(action: onRetry) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry", bundle: .module)
                        }
                    }
                    .buttonStyle(.neonPrimary)
                    Button(action: onMenu) {
                        Text("Menu", bundle: .module)
                    }
                    .buttonStyle(.ghost)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
    }

    private var scoreBlock: some View {
        VStack(spacing: 12) {
            caption(Text("Your score", bundle: .module))
            Text(verbatim: "\(score)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(PMTheme.accent)
                .shadow(color: PMTheme.accent.opacity(0.6), radius: 20)
            HStack(spacing: 8) {
                caption(Text("Best", bundle: .module))
                Text(verbatim: "\(best)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(PMTheme.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.03), in: Capsule())
            .overlay(Capsule().strokeBorder(PMTheme.accent.opacity(0.22), lineWidth: 1))
        }
    }

    private func caption(_ text: Text) -> some View {
        text
            .font(.system(size: 9, weight: .semibold, design: .monospaced))
            .textCase(.uppercase)
            .kerning(1.8)
            .foregroundStyle(PMTheme.textSecondary)
    }
}

#Preview {
    ResultView(score: 1240, best: 2600, onRetry: {}, onMenu: {})
}
