// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "learn-vapor-fluent",
    products: [
        .executable(name: "learn-vapor-fluent", targets: ["Main"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "3.3.1"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver", from: "3.0.1"),
    ],
    targets: [
        .target(name: "Main", dependencies: [
            "Vapor",
            "FluentMySQL"
            ]),
        .testTarget(name: "learn-vapor-fluentTests", dependencies: ["Main"]),
    ]
)
