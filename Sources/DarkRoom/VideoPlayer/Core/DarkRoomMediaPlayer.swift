//
//  DarkRoomPlayer.swift
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

import AVFoundation.AVPlayer

// MARK: - Abstraction

/// Abstract wrapper for `AVPlayer` to handle states and perform mutation inside encapsulated structure.
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
