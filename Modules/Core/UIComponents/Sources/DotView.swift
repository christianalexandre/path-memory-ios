import SwiftUI

public enum DotState: Sendable {
    case idle
    case lit
    case finger
    case correct
    case wrong
    case ghost
}

@MainActor
public struct DotView: View {
    private let state: DotState
    private let diameter: CGFloat

    public init(state: DotState, diameter: CGFloat) {
        self.state = state
        self.diameter = diameter
    }

    public var body: some View {
        ZStack {
            switch state {
            case .ghost:
                Circle().strokeBorder(PMTheme.accent.opacity(0.5), lineWidth: 1.6)
            case .idle:
                Circle().fill(fill)
                Circle().strokeBorder(Color.white.opacity(0.05), lineWidth: 1)
            default:
                Circle().fill(fill)
            }
        }
        .frame(width: diameter, height: diameter)
        .shadow(color: glowColor, radius: glowRadius)
    }

    private var fill: RadialGradient {
        let colors: [Color] = switch state {
        case .lit:
            [PMTheme.accentBright, PMTheme.accent, PMTheme.accent.opacity(0.55)]
        case .finger:
            [.white, PMTheme.accentBright, PMTheme.accent]
        case .correct:
            [Color(hex: 0xE2FFF1), PMTheme.success, PMTheme.success.opacity(0.6)]
        case .wrong:
            [Color(hex: 0xFFDCEC), PMTheme.danger, PMTheme.danger.opacity(0.6)]
        default:
            [Color(hex: 0x96B9C3).opacity(0.16), Color(hex: 0x5A7882).opacity(0.045)]
        }
        return RadialGradient(
            colors: colors,
            center: UnitPoint(x: 0.5, y: 0.38),
            startRadius: 0,
            endRadius: diameter * 0.7
        )
    }

    private var glowColor: Color {
        switch state {
        case .lit: PMTheme.accent.opacity(0.5)
        case .finger: PMTheme.accent.opacity(0.6)
        case .correct: PMTheme.success.opacity(0.45)
        case .wrong: PMTheme.danger.opacity(0.55)
        default: .clear
        }
    }

    private var glowRadius: CGFloat {
        switch state {
        case .lit: diameter * 0.3
        case .finger: diameter * 0.5
        case .correct: diameter * 0.28
        case .wrong: diameter * 0.42
        default: 0
        }
    }
}
