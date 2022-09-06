//
//  DarkRoomPlayer.swift
//  
//
//  Created by Kiarash Vosough on 7/13/22.
//

import AVFoundation
import Combine

// MARK: - Abstraction

public typealias DarkRoomPlayerExposable = DarkRoomPlayerCurrentState & DarkRoomMediaPlayer & DarkRoomPlayerPublishers

public protocol DarkRoomPlayerPublishers {

    var shouldEnableSeeking: AnyPublisher<Bool,Never> { get }
    
    var itemBufferProgressDidChange: AnyPublisher<Double,Never> { get }
    
    var currentTimeWillChange: AnyPublisher<Double,Never> { get }
    
    var currentTimeDidChange: AnyPublisher<Double,Never> { get }
    
    var leftTimeDidChange: AnyPublisher<Double,Never> { get }
    
    var currentTimeProgressDidChange: AnyPublisher<Double,Never> { get }
    
    var stateDidChange: AnyPublisher<DarkRoomPlayerStates,Never> { get }
    
    var stateWillChange: AnyPublisher<DarkRoomPlayerStates,Never> { get }
    
    var shouldShowActivityIndicator: AnyPublisher<Bool,Never> { get }
    
    var didItemPlayToEndTime: AnyPublisher<Double,Never> { get }
}

// MARK: - Implemntation

public final class DarkRoomPlayer: DarkRoomPlayerExposable {

    // MARK: - Variables
    
    private let shouldEnableSeekingSubject: PassthroughSubject<Bool,Never>
    
    private let itemBufferProgressDidChangeSubject: PassthroughSubject<Double,Never>
    
    private let currentTimeDidChangeSubject: PassthroughSubject<Double,Never>
    
    private let currentTimeWillChangeSubject: PassthroughSubject<Double,Never>
    
    private let currentTimeProgressDidChangeSubject: PassthroughSubject<Double,Never>
    
    private let stateDidChangeSubject: PassthroughSubject<DarkRoomPlayerStates,Never>
    
    private let stateWillChangeSubject: PassthroughSubject<DarkRoomPlayerStates,Never>
    
    private let shouldShowActivityIndicatorSubject: PassthroughSubject<Bool,Never>
    
    private let leftTimeDidChangeSubject: PassthroughSubject<Double,Never>
    
    private let didItemPlayToEndTimeSubject: PassthroughSubject<Double,Never>
    
    // MARK: - Outputs
    
    public var shouldEnableSeeking: AnyPublisher<Bool,Never> {
        shouldEnableSeekingSubject.share().eraseToAnyPublisher()
    }
    
    public var itemBufferProgressDidChange: AnyPublisher<Double,Never> {
        itemBufferProgressDidChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var currentTimeDidChange: AnyPublisher<Double,Never> {
        currentTimeDidChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var currentTimeWillChange: AnyPublisher<Double,Never> {
        currentTimeWillChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var stateDidChange: AnyPublisher<DarkRoomPlayerStates,Never> {
        stateDidChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var stateWillChange: AnyPublisher<DarkRoomPlayerStates,Never> {
        stateWillChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var shouldShowActivityIndicator: AnyPublisher<Bool,Never> {
        shouldShowActivityIndicatorSubject.share().eraseToAnyPublisher()
    }
    
    public var currentTimeProgressDidChange: AnyPublisher<Double,Never> {
        currentTimeProgressDidChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var leftTimeDidChange: AnyPublisher<Double,Never> {
        leftTimeDidChangeSubject.share().eraseToAnyPublisher()
    }
    
    public var didItemPlayToEndTime: AnyPublisher<Double,Never> {
        didItemPlayToEndTimeSubject.share().eraseToAnyPublisher()
    }

    public weak var delegate: DarkRoomPlayerDelegate?

    /// AVPlayer in use
    public var player: AVPlayer { context.player }

    /// Current player state
    public var state: DarkRoomPlayerStates { context.state.type }
    
    /// Last media requested to be load
    public var currentMedia: DarkRoomPlayerMedia? { context.currentMedia }

    /// Player's current time
    public var currentTime: Double { context.currentTime }
    
    public var totalTime: Double { context.totalTime }
    
    public var leftTime: Double { context.leftTime }
    
    public var bufferDuration: Double {
        context.bufferDuration
    }

    /// Enable/Disable loop on the current media
    public var loopMode: Bool {
        get { return context.loopMode }
        set { context.loopMode = newValue }
    }

    public var isPlaying: Bool { context.isPlaying }

    // MARK: - Input
    
    private var context: DarkRoomPlayerContext
    
    // MARK: - Init

    /// - parameter player: AVPlayer instance in use
    /// - parameter config: setup player configuration
    public init(
        player: AVPlayer = AVPlayer(),
        config: DarkRoomPlayerConfiguration = DarkRoomPlayerConfigurationImpl.default,
        assetResourceLoaderService: DarkRoomAssetResourceLoaderService? = nil
    ) {
        self.shouldEnableSeekingSubject = PassthroughSubject<Bool,Never>()
        self.itemBufferProgressDidChangeSubject = PassthroughSubject<Double,Never>()
        self.currentTimeDidChangeSubject = PassthroughSubject<Double,Never>()
        self.stateDidChangeSubject = PassthroughSubject<DarkRoomPlayerStates,Never>()
        self.stateWillChangeSubject = PassthroughSubject<DarkRoomPlayerStates,Never>()
        self.shouldShowActivityIndicatorSubject = PassthroughSubject<Bool,Never>()
        self.currentTimeProgressDidChangeSubject = PassthroughSubject<Double,Never>()
        self.leftTimeDidChangeSubject = PassthroughSubject<Double,Never>()
        self.didItemPlayToEndTimeSubject = PassthroughSubject<Double,Never>()
        self.currentTimeWillChangeSubject = PassthroughSubject<Double,Never>()
        
        let concreteContext = DarkRoomPlayerContextImpl(
            player: player,
            config: config,
            assetResourceLoaderService: assetResourceLoaderService
        )

        self.context = concreteContext
        concreteContext.delegate = self
    }
    
    deinit {
        self.shouldEnableSeekingSubject.send(completion: .finished)
        self.itemBufferProgressDidChangeSubject.send(completion: .finished)
        self.currentTimeDidChangeSubject.send(completion: .finished)
        self.stateDidChangeSubject.send(completion: .finished)
        self.stateWillChangeSubject.send(completion: .finished)
        self.shouldShowActivityIndicatorSubject.send(completion: .finished)
        self.currentTimeProgressDidChangeSubject.send(completion: .finished)
        self.leftTimeDidChangeSubject.send(completion: .finished)
        self.didItemPlayToEndTimeSubject.send(completion: .finished)
        self.currentTimeWillChangeSubject.send(completion: .finished)
    }
    
    // MARK: - Actions
    
    /// Pauses playback of the current item
    public func pause() {
        self.context.pause()
    }
    
    /// Sets the media current time to the specified position
    ///
    /// - Note: position is bounded between 0 and end time or available ranges
    /// - parameter position: time to seek
    public func seek(position: Double) {
        self.context.seek(position: position)
    }

    /// Apply offset to the media current time
    ///
    /// - Note: this method compute position then call then seek(position:)
    /// - parameter offset: offset to apply
    public func seek(offset: Double) {
        self.context.seek(offset: offset)
    }
    
    /// Stops playback of the current item then seek to 0
    public func stop() {
        self.context.stop()
    }

    /// Replaces the current player media with the new media
    ///
    /// - parameter media: media to load
    /// - parameter autostart: play after media is loaded
    /// - parameter position: seek position
    public func load(media: DarkRoomPlayerMedia, autostart: Bool, position: Double? = nil) {
        self.context.load(media: media, autostart: autostart, position: position)
    }
    
    /// Begins playback of the current item
    public func play() {
        self.context.play()
    }
}

// MARK: - DarkRoomPlayerContext Delegate

extension DarkRoomPlayer: DarkRoomPlayerContextDelegate {
    
    public func playerContextShouldShowActivityIndicator() {
        self.shouldShowActivityIndicatorSubject.send(true)
    }
    
    public func playerContextShouldHideActivityIndicator() {
        self.shouldShowActivityIndicatorSubject.send(false)
    }
    
    public func playerContextSeekingShouldEnabled() {
        self.shouldEnableSeekingSubject.send(true)
    }
    
    public func playerContextSeekingShouldDisabled() {
        self.shouldEnableSeekingSubject.send(false)
    }

    public func playerContext(didStateChange state: DarkRoomPlayerStates) {
        delegate?.player(self, didStateChange: state)
        stateDidChangeSubject.send(state)
    }
    
    public func playerContext(willStateChange state: DarkRoomPlayerStates) {
        delegate?.player(self, willStateChange: state)
        stateWillChangeSubject.send(state)
    }
    
    public func playerContext(didCurrentMediaChange media: DarkRoomPlayerMedia?) {
        delegate?.player(self, didCurrentMediaChange: media)
    }
    
    public func playerContext(willCurrentTimeChange currentTime: Double) {
        delegate?.player(self, willCurrentTimeChange: currentTime)
        currentTimeWillChangeSubject.send(currentTime)
    }
    
    public func playerContext(didCurrentTimeChange currentTime: Double) {
        delegate?.player(self, didCurrentTimeChange: currentTime)
        currentTimeDidChangeSubject.send(currentTime)
        leftTimeDidChangeSubject.send(self.leftTime)
        let progress: Double = Double(currentTime/totalTime)
        currentTimeProgressDidChangeSubject.send(progress)
    }
    
    public func playerContext(didItemDurationChange itemDuration: Double?) {
        delegate?.player(self, didItemDurationChange: itemDuration)
    }
    
    public func playerContext(didItemBufferProgressChange itemBuffer: Double) {
        itemBufferProgressDidChangeSubject.send(itemBuffer)
    }

    public func playerContext(catched error: Error) {
        delegate?.player(self, catched: error)
    }
    
    public func playerContext(didItemPlayToEndTime endTime: Double) {
        delegate?.player(self, didItemPlayToEndTime: endTime)
        didItemPlayToEndTimeSubject.send(endTime)
    }
}
