# Installation

Step by Step instruction to install ``DarkRoom`` and integrate it into your project.

## Overview

There are bunch of Dependency Manager like CocoaPods, Carthage and SPM. Here you can find out, how to use each one to install ``DarkRoom``.

## Supported Dependency Manager

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DarkRoom` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/divar-ir/DarkRoom.git", .upToNextMajor(from: "1.0.0"))
]
```

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate DarkRoom into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DarkRoom'
```


### CocoaPods

Not Supported Yet

### Carthage

Not Supported Yet
