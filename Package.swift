// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MGAPIService",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "MGAPIService",
            targets: ["MGAPIService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git", from: "5.6.0"),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", from: "4.2.0"),
    ],
    targets: [
        .target(
            name: "MGAPIService",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxAlamofire", package: "RxAlamofire"),
                .product(name: "ObjectMapper", package: "ObjectMapper"),
            ],
            path: "MGAPIService/Sources"
        ),    
    ],
    swiftLanguageVersions: [.v5]
)
