//
//  DarkRoomPlayerContext.swift
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
