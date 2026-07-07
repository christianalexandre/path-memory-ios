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
        HStack(spacing: 9) {
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
                .shadow(color: color, radius: 4)
            text
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 9)
        .background(color.opacity(0.08), in: Capsule())
        .overlay(Capsule().strokeBorder(color.opacity(0.32), lineWidth: 1))
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
