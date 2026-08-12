// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FinanceApp",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "FinanceApp", targets: ["FinanceApp"])
    ],
    targets: [
        .target(
            name: "FinanceApp",
            path: "FinanceApp"
        )
    ]
)
