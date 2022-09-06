//
//  DarkRoomPlaybackObservingService.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Combine

// MARK: - Abstraction

public protocol DarkRoomPlaybackObservingService {

    var onPlaybackStalled: AnyPublisher<Void, Never> { get }

    ///  AVPlayerItemDidPlayToEndTime notification can be triggered when buffer is empty and network is out.
    ///  We manually check if item has really reached his end time.
    var onPlayToEndTime: AnyPublisher<Void, Never> { get }

    var onFailedToPlayToEndTime: AnyPublisher<Void, Never> { get }
}

// MARK: - Implementation

internal final class DarkRoomPlaybackObservingServiceImpl: DarkRoomPlaybackObservingService {
    
    // MARK: - Input
    
    private let player: AVPlayer
    
    private var cancelables: Set<AnyCancellable>
    private var onPlaybackStalledSubject: PassthroughSubject<Void, Never>
    private var onPlayToEndTimeSubject: PassthroughSubject<Void, Never>
    private var onFailedToPlayToEndTimeSubject: PassthroughSubject<Void, Never>
    
    // MARK: - Outputs
    
    internal var onPlaybackStalled: AnyPublisher<Void, Never> { self.onPlaybackStalledSubject.share().eraseToAnyPublisher() }
    
    internal var onPlayToEndTime: AnyPublisher<Void, Never> { self.onPlayToEndTimeSubject.share().eraseToAnyPublisher() }
    
    internal var onFailedToPlayToEndTime: AnyPublisher<Void, Never> { self.onFailedToPlayToEndTimeSubject.share().eraseToAnyPublisher() }
    
    // MARK: - Init
    
    internal init(player: AVPlayer) {
        self.player = player
        self.cancelables = Set<AnyCancellable>()
        self.onPlaybackStalledSubject = PassthroughSubject<Void, Never>()
        self.onPlayToEndTimeSubject = PassthroughSubject<Void, Never>()
        self.onFailedToPlayToEndTimeSubject = PassthroughSubject<Void, Never>()
        
        NotificationCenter
            .default
            .publisher(for: .AVPlayerItemPlaybackStalled)
            .map { _ in () }
            .publish(on: onPlaybackStalledSubject)
            .store(in: &self.cancelables)
        
        NotificationCenter
            .default
            .publisher(for: .AVPlayerItemDidPlayToEndTime)
            .map { _ in () }
            .filter(or: onFailedToPlayToEndTimeSubject, { [unowned self] in
                self.hasReallyReachedEndTime(player: player)
            })
            .publish(on: onPlayToEndTimeSubject)
            .store(in: &self.cancelables)
        
        NotificationCenter
            .default
            .publisher(for: .AVPlayerItemFailedToPlayToEndTime)
            .map { _ in () }
            .publish(on: onFailedToPlayToEndTimeSubject)
            .store(in: &self.cancelables)
    }
    
    private func hasReallyReachedEndTime(player: AVPlayer) -> Bool {
        guard
            let duration = player.currentItem?.duration.seconds
            else { return false }
        
        /// item current time when receive end time notification
        /// is not so accurate according to duration
        /// added +1 make sure about the computation
        let currentTime = player.currentTime().seconds + 1
        return currentTime.rounded() >= duration.rounded()
    }
}
