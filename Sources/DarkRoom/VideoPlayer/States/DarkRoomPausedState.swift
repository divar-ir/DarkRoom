//
//  DarkRoomPausedState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation

// MARK: - Implementation

internal class DarkRoomPausedState: DarkRoomPlayerState {
    
    // MARK: - Inputs
    
    internal unowned let context: DarkRoomPlayerContext

    // MARK: - Output

    internal var isSeekingEnabled: Bool { true }
    
    // MARK: - Variable
    
    internal let type: DarkRoomPlayerStates

    // MARK: Init
    
    internal init(context: DarkRoomPlayerContext,
         type: DarkRoomPlayerStates = .paused
    ) {
        self.context = context
        self.type = type
        self.context.player.pause()
        self.context.delegate?.playerContextSeekingShouldEnabled()
    }
    
    internal func contextUpdated() {}
    
    // MARK: - Shared actions
    
    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        let state = DarkRoomLoadingMediaState(context: context, media: media, autostart: autostart, position: position)
        context.changeState(state: state)
    }

    internal func pause() {
        context
            .delegate?
            .playerContext(
                catched: DarkRoomError.playerUnavailableActionReason(
                    reason: .alreadyPaused
                )
            )
    }

    internal func play() {
        if context.currentItem?.status == .readyToPlay {
            let state = DarkRoomBufferingState(context: context)
            context.changeState(state: state)
            state.playCommand()
        } else if let media = context.currentMedia {
            let state = DarkRoomLoadingMediaState(context: context, media: media, autostart: true)
            context.changeState(state: state)
        } else {
            context
                .delegate?
                .playerContext(
                    catched: DarkRoomError.playerUnavailableActionReason(
                        reason: .loadMediaFirst
                    )
                )
        }
    }

    internal func seek(position: Double) {
        let time = CMTime(seconds: position, preferredTimescale: context.config.preferredTimescale)
        context.delegate?.playerContext(willCurrentTimeChange: context.currentTime)
        context.player.seek(to: time) { [weak self] completed in
            guard completed, let context = self?.context else { return }
            context.delegate?.playerContext(didCurrentTimeChange: context.currentTime)
        }
    }

    internal func stop() {
        context.changeState(state: DarkRoomStoppedState(context: context))
    }
}
