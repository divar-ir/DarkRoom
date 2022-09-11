# Usage

Check this article to see some example codes and hint to use ``DarkRoom``.

## How To Use DarkRoomCarousel

The Main Component of ``DarkRoom`` is ``DarkRoomCarouselViewController`` which you can use and provide it with datasource to show images or play videos.

> Do not forget to create your own strategy of loading images by implementing ``DarkRoomCarouselViewController`` and passing it to ``DarkRoomCarouselViewController`` initializer.

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
