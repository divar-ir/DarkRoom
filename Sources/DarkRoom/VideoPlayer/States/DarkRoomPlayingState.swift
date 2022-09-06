//
//  DarkRoomPlayingState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

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
