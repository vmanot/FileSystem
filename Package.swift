// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Filesystem",
    platforms: [
        .iOS("14.0"),
        .macOS("10.16"),
        .tvOS("14.0"),
        .watchOS("7.0")
    ],
    products: [
        .library(name: "Filesystem", targets: ["Filesystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Compute.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Concurrency.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Data.git", .branch("master")),
        .package(url: "https://github.com/vmanot/FoundationX.git", .branch("master")),
        .package(url: "https://github.com/vmanot/LinearAlgebra.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Merge.git", .branch("master")),
        .package(url: "https://github.com/vmanot/POSIX.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Runtime.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master")),
        .package(url: "https://github.com/vmanot/Task.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Filesystem",
            dependencies: [
                "Compute",
                "Concurrency",
                "Data",
                "FoundationX",
                "LinearAlgebra",
                "Merge",
                "POSIX",
                "Runtime",
                "Swallow",
                "Task"
            ],
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Onone"])
            ]
        )
    ]
)
