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
        .package(path: "../Compute"),
        .package(path: "../Concurrency"),
        .package(path: "../Data"),
        .package(path: "../FoundationX"),
        .package(path: "../LinearAlgebra"),
        .package(path: "../POSIX"),
        .package(path: "../Runtime"),
        .package(path: "../Swallow")
    ],
    targets: [
        .target(name: "Filesystem", dependencies: ["Compute", "Concurrency", "Data", "FoundationX", "LinearAlgebra", "POSIX", "Runtime", "Swallow"], path: "Sources")
    ],
    swiftLanguageVersions: [
        .version("5.1")
    ]
)
