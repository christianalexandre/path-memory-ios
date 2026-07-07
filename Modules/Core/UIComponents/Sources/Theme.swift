import SwiftUI

public enum PMTheme {
    public static let base = Color(hex: 0x05080D)
    public static let surfaceTop = Color(hex: 0x10202A)
    public static let surfaceMid = Color(hex: 0x070B11)

    public static let accent = Color(hex: 0x3DF0C8)
    public static let accentBright = Color(hex: 0x9DFFE9)
    public static let success = Color(hex: 0x4BF0A2)
    public static let danger = Color(hex: 0xFF3D8B)

    public static let textPrimary = Color(hex: 0xEAF6F2)
    public static let textSecondary = Color(hex: 0xEAF6F2).opacity(0.5)
    public static let textFaint = Color(hex: 0xEAF6F2).opacity(0.4)
    public static let onAccent = Color(hex: 0x052019)

    public static var playGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: 0x5AFFE0), Color(hex: 0x2FE6BD)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    public static var pillGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: 0x4FFDDF), Color(hex: 0x3DF0C8)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
