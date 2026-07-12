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
                    .padding(.top, PMSpace.xxl)
                if let review {
                    reviewBoard(review)
                        .padding(.top, PMSpace.xxl)
                }
                Spacer()
                VStack(spacing: PMSpace.lg) {
                    Button(action: onRetry) {
                        HStack(spacing: PMSpace.md) {
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
            .padding(.horizontal, PMSpace.xxxl)
            .padding(.top, PMSpace.md)
            .padding(.bottom, PMSpace.xxxl)
        }
    }

    private var scoreBlock: some View {
        VStack(spacing: PMSpace.md) {
            caption(Text("Your score", bundle: .module))
            Text(verbatim: "\(score)")
                .font(PMFont.displayXL)
                .foregroundStyle(PMTheme.accent)
                .shadow(color: PMTheme.accent.opacity(0.6), radius: 20)
            HStack(spacing: PMSpace.sm) {
                caption(Text("Best", bundle: .module))
                Text(verbatim: "\(best)")
                    .font(PMFont.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(PMTheme.textPrimary)
            }
            .padding(.horizontal, PMSpace.lg)
            .padding(.vertical, PMSpace.sm)
            .background(PMTheme.fillSubtle, in: Capsule())
            .overlay(Capsule().strokeBorder(PMTheme.accent.opacity(0.22), lineWidth: PMStroke.hairline))
        }
    }

    private func reviewBoard(_ config: GridConfiguration) -> some View {
        VStack(spacing: PMSpace.md) {
            caption(Text("The path", bundle: .module))
            GridView(configuration: config)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 180)
                .allowsHitTesting(false)
            HStack(spacing: PMSpace.xl) {
                legendItem(color: PMTheme.success, label: Text("You", bundle: .module))
                legendItem(color: PMTheme.danger, label: Text("Missed", bundle: .module))
            }
        }
    }

    private func legendItem(color: Color, label: Text) -> some View {
        HStack(spacing: PMSpace.sm) {
            Circle().fill(color).frame(width: 8, height: 8)
            label
                .font(PMFont.caption)
                .foregroundStyle(PMTheme.textSecondary)
        }
    }

    private func caption(_ text: Text) -> some View {
        text
            .font(PMFont.overline)
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
