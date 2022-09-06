//
//  DarkRoomInitializeState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import Foundation

// MARK: - Implementation

internal struct DarkRoomInitializeState: DarkRoomPlayerState {
    
    // MARK: - Input

    internal unowned let context: DarkRoomPlayerContext
    
    // MARK: - Variable
    
    internal let type: DarkRoomPlayerStates = .initialization
    
    // MARK: - Output

    internal var isSeekingEnabled: Bool { false }

    // MARK: - Init

    internal init(context: DarkRoomPlayerContext) {
        self.context = context
        self.context.delegate?.playerContextSeekingShouldDisabled()
        self.context.delegate?.playerContextShouldShowActivityIndicator()
    }
    
    internal func contextUpdated() {
        context.player.automaticallyWaitsToMinimizeStalling = false
    }
    
    // MARK: - Shared actions

    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        let state = DarkRoomLoadingMediaState(
            context: context,
            media: media,
            autostart: autostart,
            position: position
        )
        context.changeState(state: state)
    }
    
    internal func pause() {
        context.changeState(state: DarkRoomPausedState(context: context))
    }
    
    internal func play() {
        context
            .delegate?
            .playerContext(
                catched: DarkRoomError.playerUnavailableActionReason(
                    reason: .loadMediaFirst
                )
            )
    }
    
    internal func seek(position: Double) {
        context
            .delegate?
            .playerContext(
                catched: DarkRoomError.playerUnavailableActionReason(
                    reason: .loadMediaFirst
                )
            )
    }
    
    internal func stop() {
        context.changeState(state: DarkRoomStoppedState(context: context))
    }
}
