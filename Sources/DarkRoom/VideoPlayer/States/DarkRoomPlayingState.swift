//
//  DarkRoomPlayingState.swift
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
import Combine

// MARK: - Implementation

internal final class DarkRoomPlayingState: DarkRoomPlayerState {
    
    // MARK: - Inputs
    
    internal unowned let context: DarkRoomPlayerContext

    private var itemPlaybackObservingService: DarkRoomPlaybackObservingService

    private var periodicPlayingTime: CMTime { context.config.periodicPlayingTime }
    
    // MARK: - Variables
    
    private var cancelables: Set<AnyCancellable>
    
    internal let type: DarkRoomPlayerStates = .playing
    
    private var periodicTimeObserverPointer: Any?
    
    // MARK: - Output

    internal var isSeekingEnabled: Bool { true }

    // MARK: - Lifecycle

    internal init(
        context: DarkRoomPlayerContext,
        itemPlaybackObservingService: DarkRoomPlaybackObservingService
    ) {
        self.cancelables = Set<AnyCancellable>()
        self.context = context
        self.itemPlaybackObservingService = itemPlaybackObservingService
        
        self.setTimerObserver()
        self.setupPlaybackObservingCallback()
        self.context.delegate?.playerContextSeekingShouldEnabled()
        self.context.delegate?.playerContextShouldHideActivityIndicator()
    }
    
    internal func contextUpdated() {
        guard (context.currentMedia) != nil else { assertionFailure("media should exist"); return }
    }

    // MARK: - Shared actions

    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        let state = DarkRoomLoadingMediaState(
            context: context,
            media: media,
            autostart: autostart,
            position: position
        )
        changeState(state: state)
    }

    internal func pause() {
        changeState(state: DarkRoomPausedState(context: context))
    }
    
    internal func play() {
        context
            .delegate?
            .playerContext(
                catched: DarkRoomError.playerUnavailableActionReason(
                    reason: .alreadyPlaying
                )
            )
    }

    internal func seek(position: Double) {
        let state = DarkRoomBufferingState(context: context)
        changeState(state: state)
        state.seekCommand(position: position)
    }

    internal func stop() {
        let state = DarkRoomStoppedState(context: context)
        changeState(state: state)
    }

    // MARK: - Playback Observing Service
    
    private func setupPlaybackObservingCallback() {
        guard (context.currentMedia) != nil else { assertionFailure("media should exist"); return }

        itemPlaybackObservingService.onPlaybackStalled
            .sink { [weak self] in self?.redirectToWaitingForNetworkState() }
            .store(in: &self.cancelables)
        
        itemPlaybackObservingService.onFailedToPlayToEndTime
            .sink { [weak self] in self?.redirectToWaitingForNetworkState() }
            .store(in: &self.cancelables)

        itemPlaybackObservingService.onPlayToEndTime
            .sink { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.context.delegate?.playerContext(didItemPlayToEndTime: strongSelf.context.currentTime)
                if strongSelf.context.loopMode {
                    strongSelf.seek(position: 0)
                } else {
                    strongSelf.stop()
                }
            }
            .store(in: &self.cancelables)
    }
    
    private func redirectToWaitingForNetworkState() {
        let state = DarkRoomWaitingNetworkState(context: context, autostart: true, error: .playerError(reason: .playbackStalled))
        changeState(state: state)
    }
    
    // MARK: - Private actions

    private func changeState(state: DarkRoomPlayerState) {
        removeTimeObserver()
        context.changeState(state: state)
    }

    private func setTimerObserver() {
        periodicTimeObserverPointer = context
            .player
            .addPeriodicTimeObserver(forInterval: periodicPlayingTime, queue: .main) { [weak context] time in
                context?.delegate?.playerContext(didCurrentTimeChange: time.seconds)
            }
    }

    private func removeTimeObserver() {
        guard let timerObserver = periodicTimeObserverPointer else { return }

        context.player.removeTimeObserver(timerObserver)
        periodicTimeObserverPointer = nil
    }
}
