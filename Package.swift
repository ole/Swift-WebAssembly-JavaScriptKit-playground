// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let shouldBuildForEmbedded =
    Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false

let extraDependencies: [Target.Dependency] = shouldBuildForEmbedded
    ? [.product(name: "dlmalloc", package: "swift-dlmalloc")]
    : []

let swiftSettings: [SwiftSetting]? = if shouldBuildForEmbedded {
    [
        .enableExperimentalFeature("Embedded"),
        .enableExperimentalFeature("Extern"),
        .unsafeFlags([
            "-Xfrontend", "-gnone",
            "-Xfrontend", "-disable-stack-protector",
        ]),
    ]
} else {
    nil
}

let linkerSettings: [LinkerSetting]? = if shouldBuildForEmbedded {
    [
        .unsafeFlags([
            "-Xclang-linker", "-nostdlib",
            "-Xlinker", "--no-entry",
            "-Xlinker", "--export-if-defined=__main_argc_argv",
        ]),
    ]
} else {
    nil
}

let package = Package(
    name: "RenderToCanvas",
    dependencies: [
        .package(url: "https://github.com/swiftwasm/swift-dlmalloc", from: "0.1.0"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "RenderToCanvas",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ] + extraDependencies,
            cSettings: [
                .unsafeFlags(["-fdeclspec"]),
            ],
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings
        ),
    ],
    swiftLanguageModes: [.v5]
)
