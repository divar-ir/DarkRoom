//
//  DarkRoomPlayerCommand.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

// MARK: - Abstraction

/// command which ``DarkRoomMediaPlayer`` support and user can perform them.
public protocol DarkRoomPlayerCommand {
    
    /// Replaces the current player media with the new media
    ///
    /// - parameter media: media to load
    /// - parameter autostart: play after media is loaded
    /// - parameter position: seek position
    func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double?)
    
    /// Pauses playback of the current item
    func pause()
    
    /// Begins playback of the current item
    func play()
    
    /// Sets the media current time to the specified position
    ///
    /// - Note: position is bounded between 0 and end time or available ranges
    /// - parameter position: time to seek
    func seek(position: Double)
    
    /// Stops playback of the current item then seek to 0
    func stop()
}
