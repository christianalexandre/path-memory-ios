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
                .stroke(Color.white.opacity(0.08), lineWidth: 3)
            Circle()
                .trim(from: 0, to: isActive ? progress : 1)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: isActive ? ringColor.opacity(0.8) : .clear, radius: 4)
            VStack(spacing: 2) {
                Text(verbatim: "\(level)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(PMTheme.textPrimary)
                Text("Level", bundle: .module)
                    .font(.system(size: 7, weight: .semibold, design: .monospaced))
                    .textCase(.uppercase)
                    .kerning(0.8)
                    .foregroundStyle(PMTheme.textFaint)
            }
        }
        .padding(2)
        .frame(width: 54, height: 54)
    }

    private var ringColor: Color {
        guard isActive else { return Color.white.opacity(0.14) }
        return progress < 0.3 ? PMTheme.danger : PMTheme.accent
    }
}
