import SwiftUI

@MainActor
public struct TimerRing: View {
    private let level: Int
    private let progress: Double
    private let isActive: Bool

    public init(level: Int, progress: Double, isActive: Bool) {
        self.level = level
        self.progress = progress
        self.isActive = isActive
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(PMTheme.strokeFaint, lineWidth: PMStroke.thick)
            Circle()
                .trim(from: 0, to: isActive ? progress : 1)
                .stroke(ringColor, style: StrokeStyle(lineWidth: PMStroke.thick, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: isActive ? ringColor.opacity(0.8) : .clear, radius: 4)
            VStack(spacing: PMSpace.xs) {
                Text(verbatim: "\(level)")
                    .font(PMFont.headline)
                    .foregroundStyle(PMTheme.textPrimary)
                Text("Level", bundle: .module)
                    .font(PMFont.overline)
                    .textCase(.uppercase)
                    .kerning(0.8)
                    .foregroundStyle(PMTheme.textFaint)
            }
        }
        .padding(PMSpace.xs)
        .frame(width: 56, height: 56)
    }

    private var ringColor: Color {
        guard isActive else { return PMTheme.strokeStrong }
        return progress < 0.3 ? PMTheme.danger : PMTheme.accent
    }
}
