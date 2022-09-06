//
//  DarkRoomDummyImageCreator.swift
//  
//
//  Created by Karo Sahafi on 11/15/21.
//

import UIKit

internal protocol DarkRoomDummyImageCreator {
    func createDummyImageView(basedOn imageView: UIImageView?, overlay: UIImageView?) -> DarkRoomDummyImageView
}

internal extension DarkRoomDummyImageCreator {
    func createDummyImageView(basedOn imageView: UIImageView?, overlay: UIImageView?) -> DarkRoomDummyImageView {
        let frame = imageView?.frameRelativeToWindow() ?? UIScreen.main.bounds
        let dummyImageView: DarkRoomDummyImageView = DarkRoomDummyImageView(image: imageView?.image, overlayImage: overlay?.image)
        dummyImageView.frame = frame
        dummyImageView.clipsToBounds = true
        dummyImageView.contentMode = imageView?.contentMode ?? .scaleToFill
        dummyImageView.alpha = 1.0
        dummyImageView.image = imageView?.image
        dummyImageView.overlayImage = overlay?.image
        return dummyImageView
    }
}
