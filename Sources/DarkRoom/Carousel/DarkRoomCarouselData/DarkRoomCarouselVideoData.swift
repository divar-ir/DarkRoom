//
//  DarkRoomCarouselVideoData.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//
//  Copyright (c) 2022 Divar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
