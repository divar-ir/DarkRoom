//
//  DarkRoomPlayerCommand.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//
//  Copyright (c) 2022 Divar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
