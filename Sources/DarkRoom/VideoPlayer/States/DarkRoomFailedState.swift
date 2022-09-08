//
//  DarkRoomFailedState.swift
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
