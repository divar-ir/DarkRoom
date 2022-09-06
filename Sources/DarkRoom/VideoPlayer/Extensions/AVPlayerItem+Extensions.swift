//
//  AVPlayerItem+Extensions.swift
//  
//
//  Created by Kiarash Vosough on 6/29/22.
//

import AVFoundation

public extension AVPlayerItem {
    
    var bufferProgress: Double {
        return currentBufferDuration / totalDuration
    }
    
    var currentBufferDuration: Double {
        guard let range = loadedTimeRanges.first else { return 0 }
        return Double(CMTimeGetSeconds(CMTimeRangeGetEnd(range.timeRangeValue)))
    }
    
    var currentDuration: Double {
        return Double(CMTimeGetSeconds(currentTime()))
    }
    
    var playProgress: Double {
        return currentDuration / totalDuration
    }
    
    var totalDuration: Double {
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
}
