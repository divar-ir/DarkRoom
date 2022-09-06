//
//  DarkRoomCarouselData.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

public enum DarkRoomCarouselData {

    case image(data: DarkRoomCarouselImageData)
    case video(data: DarkRoomCarouselVideoData)

    var isVideo: Bool {
        switch self {
        case .image:
            return false
        case .video:
            return true
        }
    }
}
