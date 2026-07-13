// swift-tools-version: 6.0
import PackageDescription

let strict: [SwiftSetting] = [.unsafeFlags(["-warnings-as-errors"])]

/// iOS-only so the host `swift test`/coverage build never compiles the
/// snapshot toolchain (it runs only on the simulator).
let snapshotTestDeps: [Target.Dependency] = [
    .target(name: "SnapshotSupport", condition: .when(platforms: [.iOS])),
    .product(
        name: "SnapshotTesting",
        package: "swift-snapshot-testing",
        condition: .when(platforms: [.iOS])
    ),
]

let package = Package(
    name: "PathMemoryKit",
    defaultLocalization: "en",
    // macOS is declared so the logic modules stay host-testable via `swift test`.
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "GameFeature", targets: ["GameFeature"]),
        .library(name: "MenuFeature", targets: ["MenuFeature"]),
        .library(name: "UIComponents", targets: ["UIComponents"]),
        .library(name: "Persistence", targets: ["Persistence"]),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift", from: "7.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        // Core: shared infrastructure consumed by the features' Data layers.
        // Persistence (GRDB) and Haptics are added back when they get real code.
        .target(
            name: "SharedModels",
            path: "Core/SharedModels/Sources",
            swiftSettings: strict
        ),
        .testTarget(
            name: "SharedModelsTests",
            dependencies: ["SharedModels"],
            path: "Core/SharedModels/Tests",
            swiftSettings: strict
        ),
        .target(
            name: "Persistence",
            dependencies: [
                "SharedModels",
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Core/Persistence/Sources",
            swiftSettings: strict
        ),
        .testTarget(
            name: "PersistenceTests",
            dependencies: ["Persistence"],
            path: "Core/Persistence/Tests",
            swiftSettings: strict
        ),
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
        .testTarget(
            name: "UIComponentsSnapshotTests",
            dependencies: ["UIComponents"] + snapshotTestDeps,
            path: "Core/UIComponents/SnapshotTests",
            swiftSettings: strict
        ),
        // Test-only helper target shared by the per-module snapshot targets.
        .target(
            name: "SnapshotSupport",
            dependencies: [
                .product(
                    name: "SnapshotTesting",
                    package: "swift-snapshot-testing",
                    condition: .when(platforms: [.iOS])
                ),
            ],
            path: "SnapshotSupport/Sources",
            swiftSettings: strict
        ),
        // Features: each one owns its Presentation/Domain/Data layers internally.
        .target(
            name: "GameFeature",
            dependencies: [
                "UIComponents",
                "SharedModels",
                "Persistence",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
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
        .testTarget(
            name: "GameFeatureSnapshotTests",
            dependencies: ["GameFeature"] + snapshotTestDeps,
            path: "Features/GameFeature/SnapshotTests",
            swiftSettings: strict
        ),
        .target(
            name: "MenuFeature",
            dependencies: [
                "UIComponents",
                "SharedModels",
                "Persistence",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
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
        .testTarget(
            name: "MenuFeatureSnapshotTests",
            dependencies: ["MenuFeature"] + snapshotTestDeps,
            path: "Features/MenuFeature/SnapshotTests",
            swiftSettings: strict
        ),
    ]
)
