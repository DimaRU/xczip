// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "xczip",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/DimaRU/ZIPFoundation", .branch("forcedate")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "xczip",
            dependencies: [
                "ZIPFoundation",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
    ]
)
