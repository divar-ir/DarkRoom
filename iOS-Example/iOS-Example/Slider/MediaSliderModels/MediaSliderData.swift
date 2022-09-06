//
//  MediaSliderData.swift
//  IOS-Example
//
//  Created by Kiarash Vosough on 7/26/22.
//

import Foundation
import DarkRoom

enum MediaSliderData {
    case image(data: MediaSliderImageData)
    case video(data: MediaSliderVideoData)
    
    var isVideo: Bool {
        switch self {
        case .image:
            return false
        case .video:
            return true
        }
    }
}
