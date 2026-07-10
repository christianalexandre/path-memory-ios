import SwiftUI
import UIComponents

@MainActor
struct ResultView: View {
    let score: Int
    let best: Int
    let review: GridConfiguration?
    let onRetry: () -> Void
    let onMenu: () -> Void

    var body: some View {
        ZStack {
            NeonBackground()
            VStack(spacing: 0) {
                Spacer()
                PhaseBanner(Text("Game Over", bundle: .module), tone: .danger)
                scoreBlock
                    .padding(.top, 24)
                if let review {
                    reviewBoard(review)
                        .padding(.top, 24)
                }
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

    private func reviewBoard(_ config: GridConfiguration) -> some View {
        VStack(spacing: 12) {
            caption(Text("The path", bundle: .module))
            GridView(configuration: config)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 180)
                .allowsHitTesting(false)
            HStack(spacing: 18) {
                legendItem(color: PMTheme.success, label: Text("You", bundle: .module))
                legendItem(color: PMTheme.danger, label: Text("Missed", bundle: .module))
            }
        }
    }

    private func legendItem(color: Color, label: Text) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            label
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(PMTheme.textSecondary)
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
    var config = GridConfiguration(dotsPerSide: 5)
    let path = [GridPoint(0, 0), GridPoint(0, 1), GridPoint(1, 1), GridPoint(2, 1)]
    config.ghostDots = Set(path)
    config.ghostTrail = path
    config.correctDots = [GridPoint(0, 0), GridPoint(0, 1)]
    config.userTrail = [GridPoint(0, 0), GridPoint(0, 1)]
    config.userTrailColor = PMTheme.success
    config.wrongDots = [GridPoint(1, 0)]
    return ResultView(score: 1240, best: 2600, review: config, onRetry: {}, onMenu: {})
}
