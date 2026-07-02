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
        .library(name: "GRDBStorageRepository", targets: ["GRDBStorageRepository"]),
        .library(name: "CoreHapticsService", targets: ["CoreHapticsService"]),
        .library(name: "UIComponents", targets: ["UIComponents"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.0"),
        .package(url: "https://github.com/groue/GRDB.swift", from: "7.0.0"),
    ],
    targets: [
        .target(name: "Domain", path: "Domain/Sources", swiftSettings: strict),
        .testTarget(name: "DomainTests", dependencies: ["Domain"], path: "Domain/Tests", swiftSettings: strict),
        .target(
            name: "StorageRepository",
            dependencies: ["Domain", .product(name: "Dependencies", package: "swift-dependencies")],
            path: "Interfaces/StorageRepository/Sources",
            swiftSettings: strict
        ),
        .target(
            name: "HapticsService",
            dependencies: ["Domain", .product(name: "Dependencies", package: "swift-dependencies")],
            path: "Interfaces/HapticsService/Sources",
            swiftSettings: strict
        ),
        .target(
            name: "GRDBStorageRepository",
            dependencies: [
                "StorageRepository",
                "Domain",
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Data/GRDBStorageRepository/Sources",
            swiftSettings: strict
        ),
        .testTarget(
            name: "GRDBStorageRepositoryTests",
            dependencies: ["GRDBStorageRepository"],
            path: "Data/GRDBStorageRepository/Tests",
            swiftSettings: strict
        ),
        .target(
            name: "CoreHapticsService",
            dependencies: ["HapticsService", .product(name: "Dependencies", package: "swift-dependencies")],
            path: "Data/CoreHapticsService/Sources",
            swiftSettings: strict
        ),
        .target(name: "UIComponents", path: "UIComponents/Sources", swiftSettings: strict),
        .target(
            name: "GameFeature",
            dependencies: [
                "Domain",
                "StorageRepository",
                "HapticsService",
                "UIComponents",
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
        .target(
            name: "MenuFeature",
            dependencies: [
                "Domain",
                "StorageRepository",
                "UIComponents",
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
    ]
)
