import SwiftUI

public struct NeonPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 19, weight: .bold, design: .rounded))
            .foregroundStyle(PMTheme.onAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 66)
            .background(PMTheme.playGradient, in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: PMTheme.accent.opacity(configuration.isPressed ? 0.25 : 0.45), radius: 17, y: 5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == NeonPrimaryButtonStyle {
    static var neonPrimary: NeonPrimaryButtonStyle {
        NeonPrimaryButtonStyle()
    }
}

public struct GhostButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(PMTheme.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == GhostButtonStyle {
    static var ghost: GhostButtonStyle {
        GhostButtonStyle()
    }
}
