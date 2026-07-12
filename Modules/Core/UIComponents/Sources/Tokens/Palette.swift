import SwiftUI

enum Palette {
    static let neon200 = Color(hex: 0x9DFFE9)
    static let neon300 = Color(hex: 0x5AFFE0)
    static let neon400 = Color(hex: 0x4FFDDF)
    static let neon500 = Color(hex: 0x3DF0C8)
    static let neon600 = Color(hex: 0x2FE6BD)

    static let mint50 = Color(hex: 0xE2FFF1)
    static let emerald400 = Color(hex: 0x4BF0A2)
    static let emerald950 = Color(hex: 0x052019)

    static let rose50 = Color(hex: 0xFFDCEC)
    static let rose400 = Color(hex: 0xFF3D8B)

    static let ink900 = Color(hex: 0x05080D)
    static let ink850 = Color(hex: 0x070B11)
    static let ink700 = Color(hex: 0x10202A)

    static let mist50 = Color(hex: 0xEAF6F2)
    static let slate300 = Color(hex: 0x96B9C3)
    static let slate500 = Color(hex: 0x5A7882)
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
