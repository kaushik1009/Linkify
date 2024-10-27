// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Linkify",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Linkify",
            targets: ["Linkify"]
        ),
    ],
    targets: [
        .target(
            name: "Linkify",
            path: "Sources"
        ),
        .testTarget(
            name: "LinkifyTests",
            dependencies: ["Linkify"],
            path: "Tests"
        ),
    ]
)
