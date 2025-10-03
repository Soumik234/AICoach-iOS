// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AICoach",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AICoach",
            targets: ["AICoach"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.20.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.0"),
        .package(url: "https://github.com/danielgindi/Charts.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "AICoach",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "Charts", package: "Charts")
            ]
        )
    ]
)
