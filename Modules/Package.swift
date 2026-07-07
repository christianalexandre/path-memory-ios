// swift-tools-version: 6.0
import PackageDescription

let strict: [SwiftSetting] = [.unsafeFlags(["-warnings-as-errors"])]

let package = Package(
    name: "PathMemoryKit",
    defaultLocalization: "en",
    // macOS is declared so the logic modules stay host-testable via `swift test`.
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "GameFeature", targets: ["GameFeature"]),
        .library(name: "MenuFeature", targets: ["MenuFeature"]),
        .library(name: "UIComponents", targets: ["UIComponents"]),
    ],
    targets: [
        // Core: shared infrastructure consumed by the features' Data layers.
        // Persistence (GRDB) and Haptics are added back when they get real code.
        .target(
            name: "UIComponents",
            path: "Core/UIComponents/Sources",
            resources: [.process("Localizable.xcstrings")],
            swiftSettings: strict
        ),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"],
            path: "Core/UIComponents/Tests",
            swiftSettings: strict
        ),
        // Features: each one owns its Presentation/Domain/Data layers internally.
        .target(
            name: "GameFeature",
            dependencies: ["UIComponents"],
            path: "Features/GameFeature/Sources",
            resources: [.process("Localizable.xcstrings")],
            swiftSettings: strict
        ),
        .testTarget(
            name: "GameFeatureTests",
            dependencies: ["GameFeature"],
            path: "Features/GameFeature/Tests",
            swiftSettings: strict
        ),
        .target(
            name: "MenuFeature",
            dependencies: ["UIComponents"],
            path: "Features/MenuFeature/Sources",
            resources: [.process("Localizable.xcstrings")],
            swiftSettings: strict
        ),
        .testTarget(
            name: "MenuFeatureTests",
            dependencies: ["MenuFeature"],
            path: "Features/MenuFeature/Tests",
            swiftSettings: strict
        ),
    ]
)
