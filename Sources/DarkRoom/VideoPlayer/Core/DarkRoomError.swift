//
//  DarkRoomError.swift
//  
//
//  Created by Kiarash Vosough on 6/28/22.
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

import Foundation

public enum DarkRoomError: Error {

    case playerError(reason: PlayerError)
    case playerUnavailableActionReason(reason: PlayerUnavailableActionReason)
    
    public enum PlayerError: Error {
        case invalidURL(url: URL, message: String)
        case resourceLoaderDelegateFoundNil
        case loadingFailed
        case didFailToPlay(item: DarkRoomPlayerMediaItem)
        case playbackStalled
        case bufferingFailed
    }
    
    public enum PlayerUnavailableActionReason: Error {
        case alreadyPaused
        case alreadyPlaying
        case alreadyStopped
        case alreadyTryingToPlay
        case seekPositionNotAvailable
        case loadMediaFirst
        case seekOverstepPosition
        case waitEstablishedNetwork
        case waitLoadedMedia
    }
}
