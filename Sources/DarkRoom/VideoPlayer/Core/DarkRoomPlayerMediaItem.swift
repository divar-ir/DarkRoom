//
//  DarkRoomPlayerMediaItem.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation

// MARK: - Abstraction

/// abstraction for media item that player can load and play.
/// if using this protocol the item will be used to play and ``DarkRoomPlayer`` won't compose new ``AVPlayerItem``.
public protocol DarkRoomPlayerMediaItem: DarkRoomPlayerMedia {

    /// Item used by the player only once.
    var item: AVPlayerItem { get }
}
