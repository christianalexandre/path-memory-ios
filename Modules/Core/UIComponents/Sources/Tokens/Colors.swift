import SwiftUI

public enum PMTheme {
    public static let base = Palette.ink900
    public static let surfaceTop = Palette.ink700
    public static let surfaceMid = Palette.ink850

    public static let accent = Palette.neon500
    public static let accentBright = Palette.neon200
    public static let success = Palette.emerald400
    public static let danger = Palette.rose400

    public static let textPrimary = Palette.mist50
    public static let textSecondary = Palette.mist50.opacity(0.5)
    public static let textFaint = Palette.mist50.opacity(0.4)
    public static let onAccent = Palette.emerald950

    public static let successBright = Palette.mint50
    public static let dangerBright = Palette.rose50
    public static let dotIdleHighlight = Palette.slate300
    public static let dotIdleShadow = Palette.slate500

    public static let fillSubtle = Color.white.opacity(0.04)
    public static let strokeFaint = Color.white.opacity(0.06)
    public static let strokeSubtle = Color.white.opacity(0.10)
    public static let strokeStrong = Color.white.opacity(0.16)

    public static var playGradient: LinearGradient {
        LinearGradient(colors: [Palette.neon300, Palette.neon600], startPoint: .top, endPoint: .bottom)
    }

    public static var pillGradient: LinearGradient {
        LinearGradient(colors: [Palette.neon400, Palette.neon500], startPoint: .top, endPoint: .bottom)
    }
}
