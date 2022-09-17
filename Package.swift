// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Deeplinker",
    products: [
        .library(
            name: "Deeplinker",
            targets: ["Deeplinker"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Deeplinker",
            dependencies: []
        ),
        .testTarget(
            name: "DeeplinkerTests",
            dependencies: ["Deeplinker"]
        )
    ]
)
