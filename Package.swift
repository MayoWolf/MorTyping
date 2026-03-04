// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MorTyping",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MorTyping", targets: ["MorTyping"])
    ],
    targets: [
        .executableTarget(
            name: "MorTyping"
        )
    ]
)
