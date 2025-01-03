// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RenderToCanvas",
    targets: [
        .executableTarget(
            name: "RenderToCanvas",
            cSettings: [
                .unsafeFlags(["-fdeclspec"]),
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .enableExperimentalFeature("Extern"),
            ]
        ),
    ]
)
