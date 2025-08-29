// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PublisherRecorder",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "PublisherRecorder",
            targets: ["PublisherRecorder"]
        ),
    ],
    targets: [
        .target(
            name: "PublisherRecorder"
        ),
        .testTarget(
            name: "PublisherRecorderTests",
            dependencies: ["PublisherRecorder"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
