import SwiftUI

@MainActor
public struct HUDView: View {
    private let score: Int
    private let level: Int
    private let lives: Int
    private let maxLives: Int
    private let timerProgress: Double
    private let isTimerActive: Bool

    public init(
        score: Int,
        level: Int,
        lives: Int,
        maxLives: Int = 3,
        timerProgress: Double = 1,
        isTimerActive: Bool = false
    ) {
        self.score = score
        self.level = level
        self.lives = lives
        self.maxLives = maxLives
        self.timerProgress = timerProgress
        self.isTimerActive = isTimerActive
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: PMSpace.xs) {
                caption(Text("Score", bundle: .module))
                Text(verbatim: "\(score)")
                    .font(PMFont.titleLg)
                    .foregroundStyle(PMTheme.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TimerRing(level: level, progress: timerProgress, isActive: isTimerActive)
            VStack(alignment: .trailing, spacing: PMSpace.sm) {
                caption(Text("Lives", bundle: .module))
                HStack(spacing: PMSpace.sm) {
                    ForEach(0 ..< maxLives, id: \.self) { index in
                        LifePip(isOn: index < lives)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func caption(_ text: Text) -> some View {
        text
            .font(PMFont.overline)
            .textCase(.uppercase)
            .kerning(1.2)
            .foregroundStyle(PMTheme.textFaint)
    }
}

private struct LifePip: View {
    let isOn: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: PMRadius.xs)
            .fill(fillStyle)
            .overlay {
                if !isOn {
                    RoundedRectangle(cornerRadius: PMRadius.xs)
                        .strokeBorder(PMTheme.strokeStrong, lineWidth: PMStroke.thin)
                }
            }
            .frame(width: 12, height: 12)
            .rotationEffect(.degrees(45))
            .shadow(color: isOn ? PMTheme.accent.opacity(0.7) : .clear, radius: 3)
    }

    private var fillStyle: AnyShapeStyle {
        if isOn {
            AnyShapeStyle(
                RadialGradient(
                    colors: [PMTheme.accentBright, PMTheme.accent],
                    center: .center,
                    startRadius: 0,
                    endRadius: 8
                )
            )
        } else {
            AnyShapeStyle(Color.clear)
        }
    }
}
