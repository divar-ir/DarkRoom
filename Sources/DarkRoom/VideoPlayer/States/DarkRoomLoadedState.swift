//
//  DarkRoomLoadedState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation

// MARK: - Implementation

internal struct DarkRoomLoadedState: DarkRoomPlayerState {

    // MARK: - Input

    internal unowned let context: DarkRoomPlayerContext
    
    // MARK: - Variable
    
    internal let type: DarkRoomPlayerStates = .loaded

    // MARK: - Output

    internal var isSeekingEnabled: Bool { true }

    // MARK: - Init

    internal init(context: DarkRoomPlayerContext) {
        self.context = context
        
        guard (context.currentMedia) != nil else { assertionFailure(); return }

        self.context.delegate?.playerContextSeekingShouldEnabled()
        self.context.delegate?.playerContextShouldShowActivityIndicator()
    }

    internal func contextUpdated() {
        guard (context.currentMedia) != nil else { assertionFailure(); return }
        
        context.delegate?.playerContext(didItemDurationChange: context.itemDuration)
    }

    // MARK: - Shared actions
    
    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        let state = DarkRoomLoadingMediaState(context: context, media: media, autostart: autostart, position: position)
        context.changeState(state: state)
    }

    internal func pause() {
        context.changeState(state: DarkRoomPausedState(context: context))
    }

    internal func play() {
        let state = DarkRoomBufferingState(context: context)
        context.changeState(state: state)
        state.playCommand()
    }

    internal func seek(position: Double) {
        let time = CMTime(seconds: position, preferredTimescale: context.config.preferredTimescale)
        context.delegate?.playerContext(willCurrentTimeChange: context.currentTime)
        context.player.seek(to: time) { [context] completed in
            guard completed else { return }
            context.delegate?.playerContext(didCurrentTimeChange: context.currentTime)
        }
    }

    internal func stop() {
        context.changeState(state: DarkRoomStoppedState(context: context))
    }
}
