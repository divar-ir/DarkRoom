//
//  DarkRoomLoadingMediaState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Combine

// MARK: - Implementation

internal final class DarkRoomLoadingMediaState: DarkRoomPlayerState {
    
    // MARK: - Output

    internal var isSeekingEnabled: Bool { false }

    // MARK: - Input
    
    internal unowned let context: DarkRoomPlayerContext
    
    // MARK: - Variables
    
    internal let type: DarkRoomPlayerStates = .loading
    
    private var cancelables: Set<AnyCancellable>
    
    private let media: DarkRoomPlayerMedia
    
    private var autostart: Bool
    
    private var position: Double?
    
    private var itemStatusObserving: DarkRoomPlayerItemStatusObservingService?
    
    private let itemInitService: DarkRoomPlayerItemInitService
    
    private let isRevivedFromNetworkWaiting: Bool
    
    // MARK: - Init
    
    internal init(
        context: DarkRoomPlayerContext,
        media: DarkRoomPlayerMedia,
        autostart: Bool,
        position: Double? = nil,
        isRevivedFromNetworkWaiting: Bool = false,
        itemInitService: DarkRoomPlayerItemInitService = DarkRoomPlayerItemInitServiceImpl()
    ) {
        self.cancelables = Set<AnyCancellable>()
        self.context = context
        self.media = media
        self.autostart = autostart
        self.position = position
        self.isRevivedFromNetworkWaiting = isRevivedFromNetworkWaiting
        self.itemInitService = itemInitService
        self.context.delegate?.playerContextSeekingShouldDisabled()
        self.context.delegate?.playerContextShouldShowActivityIndicator()
    }
    
    internal func contextUpdated() {
        /*
         Loading a clip media from playing state, play automatically the new clip media
         Ensure player will play only when we ask
         */
        context.player.pause()

        /*
         It seems to be a good idea to reset player current item
         Fix side effect when coming from failed state, but the video player screen become black and does not offer goof UX
         So it is currently not replaced for revived video from NetworkWaitingState
         */
        
        if isRevivedFromNetworkWaiting == false { context.player.replaceCurrentItem(with: nil) }

        guard let media = context.currentMedia else { assertionFailure("media should exist"); return }
        processMedia(media)
    }

    // MARK: - Shared actions

    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        self.position = position
        self.autostart = autostart
        processMedia(media)
    }

    internal func pause() {
        cancelMediaLoading()
        context.changeState(state: DarkRoomPausedState(context: context))
    }

    internal func play() {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .waitLoadedMedia
            )
        )
    }

    internal func seek(position: Double) {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .waitLoadedMedia
            )
        )
    }

    internal func stop() {
        cancelMediaLoading()
        context.changeState(state: DarkRoomStoppedState(context: context))
    }

    // MARK: - Private actions
    
    private func cancelMediaLoading() {
        context.currentItem?.asset.cancelLoading()
        context.currentItem?.cancelPendingSeeks()
        context.player.replaceCurrentItem(with: nil)
    }
    
    private func processMedia(_ media: DarkRoomPlayerMedia) {
        // in case of network connection lost and connected again, we do not create new item and use the current one instead
        if let item = context.player.currentItem, isRevivedFromNetworkWaiting {
            startObservingItemStatus(item: item)
            context.startObservingBuffer(for: item)
        } else {
            let item = itemInitService.getItem(
                media: media,
                assetResourceLoaderDelegate: context.canUseAssetResourceLoader ? context as? AVAssetResourceLoaderDelegate : nil,
                loadedAssetKeys: context.config.itemLoadedAssetKeys
            )
            
            startObservingItemStatus(item: item)
            context.player.replaceCurrentItem(with: item)
            context.startObservingBuffer(for: item)
        }
        guard position == nil else { return }
        context.delegate?.playerContext(didCurrentTimeChange: context.currentTime)
    }
    
    private func startObservingItemStatus(item: AVPlayerItem) {
        self.itemStatusObserving = DarkRoomPlayerItemStatusObservingServiceImpl(item: item)
        self.itemStatusObserving?
            .statusChangePublisher
            .sink { [unowned self] status in
                self.moveToNextState(with: status)
            }
            .store(in: &self.cancelables)
    }

    private func moveToNextState(with status: AVPlayerItem.Status) {
        switch status {
        case .unknown:
            break
        case .failed:
            let state = DarkRoomFailedState(context: context, error: .playerError(reason: .loadingFailed))
            context.changeState(state: state)
        case .readyToPlay:
            guard let position = self.position else { moveToLoadedState(); return }
            let seekPosition = CMTime(seconds: position, preferredTimescale: context.config.preferredTimescale)
            context.delegate?.playerContext(willCurrentTimeChange: context.currentTime)
            context.player.seek(to: seekPosition) { [weak self] completed in
                guard let strongSelf = self else { return }
                guard completed else { return }
                strongSelf.context.delegate?.playerContext(didCurrentTimeChange: strongSelf.context.currentTime)
                strongSelf.moveToLoadedState()
            }
        @unknown default: break
        }
    }

    private func moveToLoadedState() {
        let state = DarkRoomLoadedState(context: self.context)
        context.changeState(state: state)
        if autostart { state.play() }
    }
}
