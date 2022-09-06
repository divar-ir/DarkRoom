//
//  DarkRoomPlayer.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation.AVPlayer

// MARK: - Abstraction

/// Abstract wrapper for ``AVPlayer`` to handle states and perform mutation inside encapsulated structure.
public protocol DarkRoomMediaPlayer: AnyObject, DarkRoomPlayerCommand {

    /// represent the current media loaded into player
    var currentMedia: DarkRoomPlayerMedia? { get }
    
    /// represent the current media's time
    /// in second.
    var currentTime: Double { get }
    
    /// represent the current media's total time
    /// in second
    var totalTime: Double { get }
    
    /// represent the current media's left time to end
    /// in second
    var leftTime: Double { get }
    
    /// determine whether the player should play after reaching end of the video
    var loopMode: Bool { get set }
    
    /// represent the current media's buffer dusration
    /// in second.
    var bufferDuration: Double { get }
    
    /// represent the `AVPlayer` is being used to play current media.
    var player: AVPlayer { get }
    
    /// represent whether the player is playing some media or not.
    var isPlaying: Bool { get }
    
    /// Apply offset to the media current time
    /// - parameter offset: offset to apply
    func seek(offset: Double)
}
