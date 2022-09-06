//
//  DarkRoomPlayerView.swift
//  
//
//  Created by Kiarash Vosough on 7/19/22.
//

import AVFoundation.AVPlayerLayer
import UIKit.UIView

/// View which its underlying layer is ``AVPlayerLayer``
/// It can be used to play video alongside an ``AVPlayer``
internal final class DarkRoomPlayerView: UIView {

    internal override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
