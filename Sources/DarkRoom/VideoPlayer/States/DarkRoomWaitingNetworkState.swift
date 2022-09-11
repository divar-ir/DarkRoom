//
//  DarkRoomWaitingNetworkState.swift
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
