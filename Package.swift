// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Fundnest",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "FundnestCore",
            targets: ["FundnestCore"]
        )
    ],
    targets: [
        .target(
            name: "FundnestCore"
        ),
        .testTarget(
            name: "FundnestCoreTests",
            dependencies: ["FundnestCore"]
        )
    ]
)
