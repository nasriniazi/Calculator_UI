// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calculator_UI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Calculator_UI",
            targets: ["Calculator_UI"]),
    ],
    dependencies: [.package(url:"https://github.com/nasriniazi/CalculatorCore.git", branch:"main"),.package(url: "https://github.com/nasriniazi/FeatureToggling.git", branch: "main"),
                   .package(url: "https://github.com/nasriniazi/Coordinator.git", branch: "main") ,.package(url: "https://github.com/nasriniazi/Theme.git", branch: "main"),.package(url:"https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0") ),],
    targets: [
        .target(
            name: "Calculator_UI",
            dependencies: [.product(name: "FeatureToggling", package: "FeatureToggling"),.product(name: "CalculatorCore", package: "CalculatorCore"),.product(name: "Coordinator", package: "Coordinator"),.product(name: "Theme", package: "Theme"),.product(name: "RxSwift", package: "RxSwift"),.product(name: "RxCocoa", package: "RxSwift")],path: "Sources",resources: [],swiftSettings: [.define("SPM")]),
        .testTarget(
            name: "Calculator_UITests",
            dependencies: ["Calculator_UI"]),
    ]
)
