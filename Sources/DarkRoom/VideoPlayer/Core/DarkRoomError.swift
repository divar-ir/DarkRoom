//
//  DarkRoomError.swift
//  
//
//  Created by Kiarash Vosough on 6/28/22.
//

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
