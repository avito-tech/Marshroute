// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Marshroute",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
    ],
    products: [
        .library(name: "Marshroute",
                 targets: ["Marshroute"]),
    ],
    targets: [
        .target(name: "Marshroute",
                path: "Marshroute/Sources"),
    ]
)
