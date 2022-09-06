//
//  MediaSliderImageData.swift
//  IOS-Example
//
//  Created by Kiarash Vosough on 7/26/22.
//

import UIKit
import DarkRoom

public struct MediaSliderImageData: DarkRoomCarouselImageData {

    public var imagePlaceholder: UIImage
    public let imageUrl: URL
    public let imageBackgroundColor: UIColor
    public let imageDescription: String

    public init(imagePlaceholder: UIImage, imageUrl: URL, imageBackgroundColor: UIColor, imageDescription: String) {
        self.imagePlaceholder = imagePlaceholder
        self.imageUrl = imageUrl
        self.imageBackgroundColor = imageBackgroundColor
        self.imageDescription = imageDescription
    }
}
