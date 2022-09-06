//
//  DarkRoomWaitingNetworkState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Combine

// MARK: - Implementation

internal final class DarkRoomWaitingNetworkState: DarkRoomPlayerState {
    
    // MARK: - Inputs
    
    internal unowned let context: DarkRoomPlayerContext
    
    private var reachability: DarkRoomReachabilityService
    
    // MARK: - Variable
    
    private var cancelables: Set<AnyCancellable>
    
    internal let type: DarkRoomPlayerStates = .waitingForNetwork
    
    // MARK: - Output

    internal var isSeekingEnabled: Bool { false }
    
    // MARK: - Init
    
    internal init(context: DarkRoomPlayerContext,
         autostart: Bool,
         error: DarkRoomError,
         reachabilityService: DarkRoomReachabilityService? = nil
    ) {
        
        self.cancelables = Set<AnyCancellable>()
        self.context = context
        self.reachability = reachabilityService ?? DarkRoomReachabilityServiceImpl(config: context.config)
        setupReachabilityCallbacks(autostart: autostart, error: error)
        self.context.delegate?.playerContextSeekingShouldDisabled()
        self.context.delegate?.playerContextShouldShowActivityIndicator()
    }

    internal func contextUpdated() {
        reachability.start()

        guard let media = context.currentMedia else { assertionFailure("media should exist"); return }
        guard let mediaItem = media as? DarkRoomPlayerMediaItem else { return }

        context.delegate?.playerContext(
            catched: DarkRoomError.playerError(
                reason: .didFailToPlay(item: mediaItem)
            )
        )
    }

    // MARK: - Reachability
    
    private func setupReachabilityCallbacks(autostart: Bool, error: DarkRoomError) {

        reachability.isTimedOut
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                
                let failedState = DarkRoomFailedState(context: strongSelf.context, error: error)
                self?.context.changeState(state: failedState)
            }
            .store(in: &self.cancelables)
        
        reachability.isReachable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReachable  in
                guard let media = self?.context.currentMedia else { assertionFailure(); return }
                guard let strongSelf = self else { return }
                guard isReachable else { return }
                
                let currentTime = strongSelf.context.player.currentTime()
                let lastKnownPosition = strongSelf.isDurationItemFinite() ? currentTime : nil
                let state = DarkRoomLoadingMediaState(context: strongSelf.context,
                                                    media: media,
                                                    autostart: autostart,
                                                    position: lastKnownPosition?.seconds,
                                                    isRevivedFromNetworkWaiting: true)
                strongSelf.context.changeState(state: state)
                
            }
            .store(in: &self.cancelables)
    }
    
    private func isDurationItemFinite() -> Bool {
        return context.itemDuration?.isFinite ?? false
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
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .waitEstablishedNetwork
            )
        )
    }
    
    internal func seek(position: Double) {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .waitEstablishedNetwork
            )
        )
    }
    
    internal func stop() {
        context.changeState(state: DarkRoomStoppedState(context: context))
    }
}
