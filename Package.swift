// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PocketPad",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "PocketPad",
            targets: ["PocketPad"]),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.24.0")
    ],
    targets: [
        .target(
            name: "PocketPad",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift")
            ]),
        .testTarget(
            name: "PocketPadTests",
            dependencies: ["PocketPad"]),
    ]
)
