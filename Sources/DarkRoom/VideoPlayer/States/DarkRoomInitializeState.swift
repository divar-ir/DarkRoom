//
//  DarkRoomInitializeState.swift
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
