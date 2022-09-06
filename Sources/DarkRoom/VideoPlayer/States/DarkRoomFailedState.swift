//
//  DarkRoomFailedState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation

// MARK: - Implementation

internal final class DarkRoomFailedState: DarkRoomPlayerState {

    // MARK: - Input

    internal unowned let context: DarkRoomPlayerContext
    private let error: DarkRoomError
    
    // MARK: - Variable
    
    internal let type: DarkRoomPlayerStates = .failed
    
    // MARK: - Output

    internal var isSeekingEnabled: Bool { false }

    // MARK: - Init
    
    internal init(context: DarkRoomPlayerContext, error: DarkRoomError) {
        self.context = context
        self.error = error
        self.context.delegate?.playerContextSeekingShouldDisabled()
        self.context.delegate?.playerContextShouldShowActivityIndicator()
    }
    
    internal func contextUpdated() {
        guard let media = context.currentMedia else { assertionFailure("media should exist"); return }
        guard let mediaItem = media as? DarkRoomPlayerMediaItem else { return }
        context.delegate?.playerContext(catched: DarkRoomError.playerError(reason: .didFailToPlay(item: mediaItem)))
    }

    // MARK: - Shared actions

    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        let state = DarkRoomLoadingMediaState(context: context, media: media, autostart: autostart, position: position)
        context.changeState(state: state)
    }

    internal func pause() {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .loadMediaFirst
            )
        )
    }

    internal func play() {
        guard let media = context.currentMedia else {
            assertionFailure("should not possible to be in failed state without load any media")
            return
        }
        
        let state = DarkRoomLoadingMediaState(context: context, media: media, autostart: true)
        context.changeState(state: state)
    }

    internal func seek(position: Double) {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .loadMediaFirst
            )
        )
    }

    internal func stop() {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .loadMediaFirst
            )
        )
    }
}
