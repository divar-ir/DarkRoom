//
//  MediaSliderVideoData.swift
//  IOS-Example
//
//  Created by Kiarash Vosough on 7/26/22.
//

import UIKit
import DarkRoom

public struct MediaSliderVideoData: DarkRoomCarouselVideoData {

    public var overlayURL: URL?
    public var imagePlaceholder: UIImage
    public let videoImageUrl: URL
    public let videoUrl: URL
    public let imageBackgroundColor: UIColor
    public let imageDescription: String

    public init(overlayURL: URL?, imagePlaceholder: UIImage, videoImageUrl: URL, videoUrl: URL, imageBackgroundColor: UIColor, imageDescription: String) {
        self.overlayURL = overlayURL
        self.imagePlaceholder = imagePlaceholder
        self.videoImageUrl = videoImageUrl
        self.videoUrl = videoUrl
        self.imageBackgroundColor = imageBackgroundColor
        self.imageDescription = imageDescription
    }
}
