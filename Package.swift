// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "DarkRoom",
	platforms: [
		.iOS(.v13)
	],
    products: [
        .library(
            name: "DarkRoom",
            targets: ["DarkRoom"])
	],
    dependencies: [],
	targets: [
		.target(
			name: "DarkRoom",
            dependencies: [],
            path: "Sources",
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        )
	]
)
