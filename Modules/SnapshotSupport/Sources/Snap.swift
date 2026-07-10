#if canImport(UIKit)
    import SnapshotTesting
    import SwiftUI

    public enum Snap {
        private static let config: ViewImageConfig = .iPhone13Pro
        private static let traits = UITraitCollection(userInterfaceStyle: .dark)

        // perceptualPrecision tolerates the glow/AA color drift this neon theme
        // produces across renderer versions; precision still catches structural change.
        private static let precision: Float = 1
        private static let perceptual: Float = 0.98

        public static func device<V: View>() -> Snapshotting<V, UIImage> {
            .image(
                precision: precision,
                perceptualPrecision: perceptual,
                layout: .device(config: config),
                traits: traits
            )
        }

        public static func sized<V: View>(_ size: CGSize) -> Snapshotting<V, UIImage> {
            .image(
                precision: precision,
                perceptualPrecision: perceptual,
                layout: .fixed(width: size.width, height: size.height),
                traits: traits
            )
        }
    }
#endif
