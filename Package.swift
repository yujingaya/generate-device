// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "GenerateDevice",
    products: [
        .executable(name: "generate-device", targets: ["GenerateDevice"]),
        .library(name: "Device", targets: ["Device"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.15.1"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.10.1"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.14.1"),
    ],
    targets: [
        .executableTarget(
            name: "GenerateDevice",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "Device"),
            ],
            resources: [
                .copy("Templates")
            ]
        ),
        .target(
            name: "Device",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit"),
            ]
        ),
    ]
)
