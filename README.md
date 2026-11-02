# Network Middle OpenAPI Runtime Extension

The framework use to request Network API.

## Installation

Add this package to your Package.swift as dependency and to your target.

```swift
dependencies: [
    .package(
        url: "https://github.com/amine2233/swift-networking-middle-openapi-runtime.git",
        from: "1.0.0"
    )
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "NetworkingMiddleOpenApiRuntime", package: "swift-networking-middle-openapi-runtime"),
    ])
]
```

Import in your code

```swift
import NetworkingMiddleOpenApiRuntime
```
