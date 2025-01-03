// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Copied (with slight modifications) from Simon Leeb
// Source: https://github.com/sliemeobn/elementary-dom/blob/85e6aa4f35cfd4920edb767014fc58bed25e7fd6/Package.swift
// More info: https://forums.swift.org/t/web-app-with-embedded-swift-poc-demo/75486

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
    name: "SwiftWasmJavaScriptKitPlayground",
    dependencies: [
        .package(url: "https://github.com/swiftwasm/swift-dlmalloc", from: "0.1.0"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "WasmLib",
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
