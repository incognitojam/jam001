// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BrowserJam",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "BrowserLib", targets: ["BrowserLib"]),
        .executable(name: "BrowserJam", targets: ["BrowserJam"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "BrowserLib"),
        .executableTarget(name: "BrowserJam", dependencies: ["BrowserLib"]),
    ]
)
