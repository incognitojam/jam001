// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BrowserJam",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "BrowserLib", targets: ["BrowserLib"]),
        .executable(name: "BrowserJam", targets: ["BrowserJam"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.1"),
        .package(
            url: "https://github.com/incognitojam/SwiftGLFW.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-testing.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BrowserLib",
            dependencies: ["SwiftMath", .product(name: "SwiftGLFW", package: "SwiftGLFW")],
            cSettings: [
                .define(
                    "GL_SILENCE_DEPRECATION",
                    .when(platforms: [.macOS]))
            ]),
        .testTarget(
            name: "BrowserLibTests",
            dependencies: ["BrowserLib", .product(name: "Testing", package: "swift-testing")]),
        .executableTarget(name: "BrowserJam", dependencies: ["BrowserLib"]),
    ]
)

#if os(Linux)

    package.targets += [
        .systemLibrary(
            name: "OpenGL",
            pkgConfig: "gl",
            providers: [.apt(["libglu1-mesa-dev", "mesa-common-dev"])])
    ]

    package.targets[0].dependencies += ["OpenGL"]

#endif
