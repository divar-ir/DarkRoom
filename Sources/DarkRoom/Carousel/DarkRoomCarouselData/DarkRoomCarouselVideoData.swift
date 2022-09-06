//
//  DarkRoomCarouselVideoData.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

// MARK: - Abstraction

public protocol DarkRoomCarouselVideoData: DarkRoomCarouselAbstractData {
    
    /// The video media can have an image that will be shown before the video starts to play.
    /// If not providing one, the imagePlaceHolder will be shown instead.
    /// - Parameter index: The index of the video's image which should be load.
    /// - Returns: The url of the video's image.
    var videoImageUrl: URL { get }
    
    /// Provide carousel with appropriate url of video which should be load.
    /// - Parameter index: The index of the media which should be load.
    /// - Returns: The url of media which should be load.
    var videoUrl: URL { get }
    
    /// The url of media which is about to load for placing it on the main ImageView on ``DarkRoomPlayerViewController`` preview
    /// - Parameter index: The index of the media which can be provided with overlay
    /// - Returns: The url of the overlayImage
    var overlayURL: URL? { get }
}

// MARK: - Implementation

public struct DarkRoomCarouselVideoDataImpl: DarkRoomCarouselVideoData {
    
    public var videoImageUrl: URL
    
    public var videoUrl: URL
    
    public var overlayURL: URL?
    
    public var imagePlaceholder: UIImage
    
    public init(videoImageUrl: URL, videoUrl: URL, overlayURL: URL?, imagePlaceholder: UIImage) {
        self.videoImageUrl = videoImageUrl
        self.videoUrl = videoUrl
        self.overlayURL = overlayURL
        self.imagePlaceholder = imagePlaceholder
    }
}
