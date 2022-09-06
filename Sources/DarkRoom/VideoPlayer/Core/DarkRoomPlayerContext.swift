//
//  DarkRoomPlayerContext.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Combine

// MARK: - Abstraction

public protocol DarkRoomPlayerContext: DarkRoomMediaPlayer {
    
    var config: DarkRoomPlayerConfiguration { get }
    
    var currentMedia: DarkRoomPlayerMedia? { get set }
    
    var currentItem: AVPlayerItem? { get }
    
    var delegate: DarkRoomPlayerContextDelegate? { get }
    
    var itemDuration: Double? { get }

    var state: DarkRoomPlayerState! { get }

    var canUseAssetResourceLoader: Bool { get }
    
    func changeState(state: DarkRoomPlayerState)
    
    func startObservingBuffer(for item: AVPlayerItem)
}


// MARK: - Delegate

public protocol DarkRoomPlayerContextDelegate: AnyObject {
    
    func playerContext(willStateChange state: DarkRoomPlayerStates)
    
    func playerContext(didStateChange state: DarkRoomPlayerStates)
    
    func playerContext(didCurrentMediaChange media: DarkRoomPlayerMedia?)
    
    func playerContext(willCurrentTimeChange currentTime: Double)
    
    func playerContext(didCurrentTimeChange currentTime: Double)
    
    func playerContext(didItemDurationChange itemDuration: Double?)
    
    func playerContext(catched error: Error)
    
    func playerContext(didItemPlayToEndTime endTime: Double)
    
    func playerContext(didItemBufferProgressChange itemBuffer: Double)
    
    func playerContextSeekingShouldEnabled()
    
    func playerContextSeekingShouldDisabled()
    
    func playerContextShouldShowActivityIndicator()
    
    func playerContextShouldHideActivityIndicator()
}

// MARK: - Implementation

internal final class DarkRoomPlayerContextImpl: NSObject, DarkRoomPlayerContext {
    
    // MARK: - Inputs
    
    internal var config: DarkRoomPlayerConfiguration

    internal let player: AVPlayer

    internal var loopMode = false
    
    private let assetResourceLoaderService: DarkRoomAssetResourceLoaderService?
    
    private var bufferObserverService: DarkRoomBufferObserverService?
    
    internal weak var delegate: DarkRoomPlayerContextDelegate?
    
    // MARK: - Variables
    
    internal var currentItem: AVPlayerItem? {
        player.currentItem
    }

    internal var currentMedia: DarkRoomPlayerMedia? {
        didSet { delegate?.playerContext(didCurrentMediaChange: currentMedia) }
    }

    internal var currentTime: Double {
        currentItem?.currentDuration ?? 0.0
    }

    internal var itemDuration: Double? {
        currentItem?.duration.seconds
    }
    
    internal var totalTime: Double {
        currentItem?.totalDuration ?? 0.0
    }
    
    internal var leftTime: Double {
        totalTime - currentTime
    }
    
    internal var bufferDuration: Double {
        currentItem?.currentBufferDuration ?? -1
    }
    
    internal var isPlaying: Bool {
        switch self.state.type {
        case .playing: return true
        default: return false
        }
    }
    
    internal var canUseAssetResourceLoader: Bool { assetResourceLoaderService != nil }
    
    private var cancelables: Set<AnyCancellable>

    internal var state: DarkRoomPlayerState! {
        willSet {
            delegate?.playerContext(willStateChange: newValue.type)
        }
        didSet {
            state.contextUpdated()
            delegate?.playerContext(didStateChange: state.type)
        }
    }

    // MARK: - LifeCycle
    
    internal init(
        player: AVPlayer,
        config: DarkRoomPlayerConfiguration,
        assetResourceLoaderService: DarkRoomAssetResourceLoaderService?
    ) {
        self.player = player
        self.config = config
        self.assetResourceLoaderService = assetResourceLoaderService
        self.cancelables = Set<AnyCancellable>()

        super.init()

        setAllowsExternalPlayback()
        
        // defer use to execute didSet state instruction
        defer {
            // initialize initial state
            state = DarkRoomInitializeState(context: self)
        }
    }
    
    private func setAllowsExternalPlayback() {
        player.allowsExternalPlayback = config.allowsExternalPlayback
    }

    // MARK: - Public functions

    internal func changeState(state: DarkRoomPlayerState) {
        self.state = state
    }

    internal func pause() {
        state.pause()
    }

    internal func seek(position: Double) {
        guard let item = currentItem else {
            delegate?.playerContext(catched: DarkRoomError.playerUnavailableActionReason(reason: .loadMediaFirst))
            return
        }

        let seekService = DarkRoomSeekServiceImpl(preferredTimescale: config.preferredTimescale)
        do {
            let boundedPosition = try seekService.boundedPosition(position, item: item)

            state.seek(position: boundedPosition)
        } catch let error {
            delegate?.playerContext(catched: error)
        }
    }

    internal func seek(offset: Double) {
        let position = currentTime + offset
        seek(position: position)
    }

    internal func stop() {
        state.stop()
    }

    internal func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double?) {
        currentMedia = media
        state.load(media: media, autostart: autostart, position: position)
    }
    
    internal func startObservingBuffer(for item: AVPlayerItem) {
        self.bufferObserverService = DarkRoomBufferObserverServiceImpl(playerItem: item)

        self.bufferObserverService?
            .bufferDidChange
            .receiveOnMainQueue()
            .sink { bufferProgress in
                self.delegate?.playerContext(didItemBufferProgressChange: bufferProgress)
            }
            .store(in: &self.cancelables)
    }

    internal func play() {
        state.play()
    }
}

// MARK: - AVAssetResourceLoader Delegate

extension DarkRoomPlayerContextImpl: AVAssetResourceLoaderDelegate {

    internal func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest
    ) -> Bool {
        assetResourceLoaderService?.shouldWaitForLoading(of: loadingRequest) ?? false
    }
    
    internal func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        didCancel loadingRequest: AVAssetResourceLoadingRequest
    ) {
        assetResourceLoaderService?.cancel(loadingRequest: loadingRequest)
    }
}
