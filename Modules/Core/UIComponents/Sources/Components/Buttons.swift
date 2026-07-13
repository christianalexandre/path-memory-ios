import SwiftUI

public struct NeonPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(PMFont.title)
            .foregroundStyle(PMTheme.onAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(PMTheme.playGradient, in: RoundedRectangle(cornerRadius: PMRadius.xxl))
            .shadow(color: PMTheme.accent.opacity(configuration.isPressed ? 0.25 : 0.45), radius: 17, y: 5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: PMDuration.fast), value: configuration.isPressed)
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
            .font(PMFont.callout)
            .foregroundStyle(PMTheme.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(PMTheme.fillSubtle, in: RoundedRectangle(cornerRadius: PMRadius.xl))
            .overlay(RoundedRectangle(cornerRadius: PMRadius.xl).strokeBorder(
                PMTheme.strokeSubtle,
                lineWidth: PMStroke.hairline
            ))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: PMDuration.fast), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == GhostButtonStyle {
    static var ghost: GhostButtonStyle {
        GhostButtonStyle()
    }
}
