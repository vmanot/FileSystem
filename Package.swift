// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Filesystem",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Filesystem", targets: ["Filesystem"])
    ],
    dependencies: [
        .package(url: "git@github.com:vmanot/Compute.git", .branch("master")),
        .package(url: "git@github.com:vmanot/Concurrency.git", .branch("master")),
        .package(url: "git@github.com:vmanot/Data.git", .branch("master")),
        .package(url: "git@github.com:vmanot/FoundationX.git", .branch("master")),
        .package(url: "git@github.com:vmanot/LinearAlgebra.git", .branch("master")),
        .package(url: "git@github.com:vmanot/POSIX.git", .branch("master")),
        .package(url: "git@github.com:vmanot/Runtime.git", .branch("master")),
        .package(url: "git@github.com:vmanot/Swallow.git", .branch("master")),
    ],
    targets: [
        .target(name: "Filesystem", dependencies: ["Compute", "Concurrency", "Data", "FoundationX", "LinearAlgebra", "POSIX", "Runtime", "Swallow"], path: "Sources")
    ],
    swiftLanguageVersions: [
        .version("5.1")
    ]
)
