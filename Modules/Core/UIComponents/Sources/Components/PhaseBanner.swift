import SwiftUI

public enum PhaseTone: Sendable {
    case neutral
    case success
    case danger
}

@MainActor
public struct PhaseBanner: View {
    private let text: Text
    private let tone: PhaseTone

    public init(_ text: Text, tone: PhaseTone = .neutral) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        HStack(spacing: PMSpace.sm) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .shadow(color: color, radius: 4)
            text
                .font(PMFont.callout)
                .foregroundStyle(color)
        }
        .padding(.horizontal, PMSpace.xl)
        .padding(.vertical, PMSpace.sm)
        .background(color.opacity(0.08), in: Capsule())
        .overlay(Capsule().strokeBorder(color.opacity(0.32), lineWidth: PMStroke.hairline))
        .shadow(color: color.opacity(0.16), radius: 12)
    }

    private var color: Color {
        switch tone {
        case .neutral: PMTheme.accent
        case .success: PMTheme.success
        case .danger: PMTheme.danger
        }
    }
}
