// swift-tools-version: 6.0
// Root manifest for the BRubinson fork: the same package as swift/Package.swift, rooted here so a
// path dependency on this directory gets the SwiftPM identity "msplat" and the prebuilt core is found.
import PackageDescription

let package = Package(
    name: "Msplat",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Msplat", targets: ["Msplat"]),
    ],
    targets: [
        // Pre-built core library; scripts/build-xcframework.sh produces it at the repo root.
        .binaryTarget(
            name: "MsplatCore",
            path: "MsplatCore.xcframework"
        ),

        .target(
            name: "Msplat",
            dependencies: ["MsplatCore"],
            path: "swift/Sources/Msplat",
            resources: [.copy("Resources/default.metallib")],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("MetalPerformanceShaders"),
                .linkedFramework("Foundation"),
                .linkedFramework("ImageIO"),
                .linkedFramework("CoreGraphics"),
                .unsafeFlags(["-lc++"]),
            ]
        ),

        .testTarget(
            name: "MsplatTests",
            dependencies: ["Msplat"],
            path: "swift/Tests"
        ),
    ]
)
