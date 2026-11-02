// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "networking-middle-openapi-runtime",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other
        // packages.
        .library(
            name: "NetworkingMiddleOpenApiRuntime",
            targets: ["NetworkingMiddleOpenApiRuntime"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/amine2233/swift-networking-middle.git",
            from: "1.0.0"
        ),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkingMiddleOpenApiRuntime",
            dependencies: [
                .product(name: "NetworkingMiddle", package: "swift-networking-middle"),
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(
                    name: "HTTPTypes",
                    package: "swift-http-types"
                )
            ]
        ),
        .testTarget(
            name: "NetworkingMiddleOpenApiRuntimeTests",
            dependencies: ["NetworkingMiddleOpenApiRuntime"]
        )
    ]
)
