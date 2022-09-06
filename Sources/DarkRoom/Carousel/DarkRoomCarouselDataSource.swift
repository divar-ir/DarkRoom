//
//  DarkRoomCarouselDataSource.swift
//  
//
//  Created by Kiarash Vosough on 7/31/22.
//

import UIKit

/// DataSource for ``DarkRoomCarouselViewController``
public protocol DarkRoomCarouselDataSource: AnyObject {
    
    /// Indicates the number of media which ``DarkRoomCarouselViewController`` should display
    func numberOfAssets() -> Int
    
    func assetData(at index: Int) -> DarkRoomCarouselData
    
    /// In case of using transition between controller and ``DarkRoomCarouselViewController``
    ///  the source imageview is needed to perform transition animations
    /// - Parameter index: The index of the media which is about to load and need to be animated on transition
    /// - Returns: The ImageView which will be animated to show on the carousel
    func imageView(at index: Int) -> UIImageView?
    
    /// In case of using transition between controller and ``DarkRoomCarouselViewController``
    ///  the source overlayimageview is needed to perform transition animations
    /// This feature is now work just with video media
    /// Overlays are not mandatory to provide, it will be placed on the source ImageView as a complementary view
    /// - Parameter index: The index of the media which is about to load and need to be animated on transition
    /// - Returns: The overlayImageView which will be animated to show on the carousel
    func overlayImageView(at index: Int) -> UIImageView?
}

/// Optional methods
extension DarkRoomCarouselDataSource {

    func overlayImageView(at index: Int) -> UIImageView? { nil }
}
