//
//  AVPlayer+Extensions.swift
//  
//
//  Created by Kiarash Vosough on 6/29/22.
//

import AVFoundation
import UIKit

public extension AVPlayer {
    
    var bufferProgress: Double {
        return currentItem?.bufferProgress ?? -1
    }
    
    var currentBufferDuration: Double {
        return currentItem?.currentBufferDuration ?? -1
    }
    
    var currentDuration: Double {
        return currentItem?.currentDuration ?? -1
    }
    
    var isEnded: Bool {
        currentDuration == totalDuration
    }
    
    var currentImage: UIImage? {
        guard
            let playerItem = currentItem,
            let cgImage = try? AVAssetImageGenerator(asset: playerItem.asset).copyCGImage(at: currentTime(), actualTime: nil)
            else { return nil }

        return UIImage(cgImage: cgImage)
    }
    
    var playProgress: Double {
        return currentItem?.playProgress ?? -1
    }
    
    var totalDuration: Double {
        return currentItem?.totalDuration ?? -1
    }
    
    convenience init(asset: AVURLAsset) {
        self.init(playerItem: AVPlayerItem(asset: asset))
    }
    
}
