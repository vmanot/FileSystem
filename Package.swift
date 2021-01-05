// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Filesystem",
    platforms: [
        .iOS("14.0"),
        .macOS("11.0"),
        .tvOS("14.0"),
        .watchOS("7.0")
    ],
    products: [
        .library(name: "Filesystem", targets: ["Filesystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Compute.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Data.git", .branch("master")),
        .package(url: "https://github.com/vmanot/FoundationX.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Merge.git", .branch("master")),
        .package(url: "https://github.com/vmanot/POSIX.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Runtime.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Filesystem",
            dependencies: [
                "Compute",
                "Data",
                "FoundationX",
                "Merge",
                "POSIX",
                "Runtime",
                "Swallow"
            ],
            path: "Sources"
        )
    ]
)
