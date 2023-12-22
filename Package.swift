// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TextFontDescriptor",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "TextFontDescriptor", targets: ["TextFontDescriptor"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "TextFontDescriptor",
      dependencies: [
      ],
      path: "Sources"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
