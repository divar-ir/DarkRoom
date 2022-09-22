
<p align="center">
  <img src="https://github.com/divar-ir/DarkRoom/blob/pre-release-issues/Sources/DarkRoom/DarkRoom.docc/Resources/DarkRoomLogo.png">
</p>

# DarkRoom

[![Swift](https://img.shields.io/badge/Swift-5.0_or_Higher-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.0-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_13_or_Higher-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-Green?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

Elegant Media Viewer Written In Swift.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [SampleProjects](#sample)
- [Usage](#usage)
- [Contributors](#contributors)
- [License](#license)

## Features

- [x] Presenting/Dismissing Images And Videos With Showy Animations.
- [x] Play Video With Custom Control Configuration.
- [x] Support Custom Configuration For Almost Each Component.
- [x] Support HLS And Local Videos.
- [x] Documented By DocC **[Link To Documents](https://divar-ir.github.io/DarkRoom/documentation/darkroom)**.
- [ ] Support `AVAssetResourceLoaderDelegate`.
- [ ] Support `CocoaPods`(soon)
- [ ] Support `Carthage`


## Requirements

| Platform | Minimum Swift Version | Minimum Swift Tools Version | Installation | Status |
| --- | --- | --- | --- | --- |
| iOS 13.0+ | 5.0 | 5.5 | [SPM](#SwiftPackageManager) | Tested |

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DarkRoom` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/divar-ir/DarkRoom.git", .upToNextMajor(from: "1.0.0"))
]
```

## Sample

We have provided one sample project in the repository. To use it clone the repo, Source files for these are in the `iOS-Example` directory in project navigator. Have fun!

## Usage

The Main Component is ``DarkRoomCarouselViewController`` which you can use and provide it with datasource to show images or play videos.

> Do not forget to create your own strategy of loading images by implementing ``DarkRoomImageLoader`` and passing it to ``DarkRoomCarouselViewController`` initializer.

> In case you are using CollectionView to open ``DarkRoomCarouselViewController`` and the datasource is shared, consider providing `initialIndex`, or the datasource will request for wrong data and causes undefined behaviors.

```swift
let carouselController = DarkRoomCarouselViewController(
    imageDataSource: self,
    imageDelegate: self,
    imageLoader: ImageLoaderImpl(),
    initialIndex: 0,
    configuration: DarkRoomCarouselDefaultConfiguration()
)

self.present(carouselController, animated: true)
```

## Inspiration

The first version of this library was inspired by [ImageViewer.Swift](https://github.com/michaelhenry/ImageViewer.swift)

## Contributors

Feel free to share your ideas or any other problems. Pull requests are welcomed.

## License

`DarkRoom` was released under an MIT license. See [LICENSE](https://github.com/divar-ir/DarkRoom/blob/master/LICENSE) for more information.
