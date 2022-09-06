//
//  DarkRoomCarouselImageData.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

// MARK: - Abstraction

public protocol DarkRoomCarouselImageData: DarkRoomCarouselAbstractData {
    
    /// Provide carousel with appropriate url of image which should be load.
    /// - Parameter index: The index of the media which should be load.
    /// - Returns: The url of media which should be load.
    var imageUrl: URL { get }
}

// MARK: - Implementation

public struct DarkRoomCarouselImageDataImpl: DarkRoomCarouselImageData {
    
    public var imageUrl: URL
    
    public var overlayURL: URL?
    
    public var imagePlaceholder: UIImage
    
    public init(imageUrl: URL, overlayURL: URL?, imagePlaceholder: UIImage) {
        self.imageUrl = imageUrl
        self.overlayURL = overlayURL
        self.imagePlaceholder = imagePlaceholder
    }
}
