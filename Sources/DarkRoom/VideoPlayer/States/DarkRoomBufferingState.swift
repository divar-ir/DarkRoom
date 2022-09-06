//
//  DarkRoomBufferingState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Combine

// MARK: - Implementation

internal final class DarkRoomBufferingState: DarkRoomPlayerState {
    
    // MARK: - Inputs
    
    internal unowned let context: DarkRoomPlayerContext
    private var rateObservingService: DarkRoomRateObservingService
    private var playerCurrentTime: Double { context.currentTime }
    
    // MARK: - Variable
    
    private var cancelables: Set<AnyCancellable>
    
    internal let type: DarkRoomPlayerStates = .buffering

    // MARK: - Output

    public var isSeekingEnabled: Bool { true }

    // MARK: - Init

    internal init(
        context: DarkRoomPlayerContext,
        rateObservingService: DarkRoomRateObservingService? = nil
    )
    {
        guard let item = context.currentItem else { fatalError("item should exist") }
        self.cancelables = Set<AnyCancellable>()
        self.context = context
        self.rateObservingService = rateObservingService ?? DarkRoomRateObservingServiceImpl(config: context.config, item: item)

        self.setupRateObservingCallback()
        self.context.delegate?.playerContextSeekingShouldEnabled()
        self.context.delegate?.playerContextShouldShowActivityIndicator()
    }
    
    internal func contextUpdated() {
        guard context.currentMedia != nil else { assertionFailure("media should exist"); return }
    }
    
    // MARK: - Setup
    
    private func setupRateObservingCallback() {

        rateObservingService.timeoutEventPublisher
            .sink { [unowned self] _ in
                let waitingState = DarkRoomWaitingNetworkState(
                    context: context,
                    autostart: true,
                    error: .playerError(reason: .bufferingFailed)
                )
                context.changeState(state: waitingState)
            }
            .store(in: &self.cancelables)
        
        guard context.currentMedia != nil else { assertionFailure("media should exist"); return }
        
        rateObservingService.playingEventPublisher
            .sink { [context] in
                let playbackService = DarkRoomPlaybackObservingServiceImpl(player: context.player)
                context.changeState(
                    state: DarkRoomPlayingState(
                        context: context,
                        itemPlaybackObservingService: playbackService
                    )
                )
            }
            .store(in: &self.cancelables)
    }
    
    // MARK: - Player Commands

    internal func playCommand() {
        rateObservingService.start()
        context.player.play()
    }

    internal func seekCommand(position: Double) {
        context.currentItem?.cancelPendingSeeks()
        let time = CMTime(seconds: position, preferredTimescale: context.config.preferredTimescale)
        context.delegate?.playerContext(willCurrentTimeChange: context.currentTime)
        context.player.seek(to: time) { [weak self] completed in
            guard completed, let strongSelf = self else { return }
            strongSelf.context.delegate?.playerContext(didCurrentTimeChange: strongSelf.context.currentTime)
            strongSelf.playCommand()
        }
    }

    // MARK: - Shared actions

    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        let state = DarkRoomLoadingMediaState(context: context,
                                      media: media,
                                      autostart: autostart,
                                      position: position)
        self.changeState(state)
    }

    internal func pause() {
        changeState(DarkRoomPausedState(context: context))
    }

    internal func play() {
        context
            .delegate?
            .playerContext(
                catched: DarkRoomError.playerUnavailableActionReason(
                    reason: .alreadyTryingToPlay
                )
            )
    }

    internal func seek(position: Double) {
        seekCommand(position: position)
    }

    internal func stop() {
        changeState(DarkRoomStoppedState(context: context))
    }
    
    // MARK: - Private
    
    private func changeState(_ state: DarkRoomPlayerState) {
        rateObservingService.stop(clearCallbacks: true)
        context.currentItem?.cancelPendingSeeks()
        context.changeState(state: state)
    }
}
