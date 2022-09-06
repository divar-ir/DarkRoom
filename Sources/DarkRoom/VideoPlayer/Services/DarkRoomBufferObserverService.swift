//
//  DarkRoomBufferObserverService.swift
//  
//
//  Created by Kiarash Vosough on 7/16/22.
//

import Foundation
import Combine
import AVFoundation

// MARK: - Abstraction

public protocol DarkRoomBufferObserverService {
    var bufferDidChange: AnyPublisher<Double,Never> { get }
}

// MARK: - Implementation

internal final class DarkRoomBufferObserverServiceImpl: DarkRoomBufferObserverService {
    
    // MARK: - Inputs
    
    private let playerItem: AVPlayerItem
    
    // MARK: - Variables
    
    private let bufferDidChangeSubject: PassthroughSubject<Double,Never>
    
    private var cancelables: Set<AnyCancellable>
    
    // MARK: - Outputs
    
    internal var bufferDidChange: AnyPublisher<Double, Never> {
        bufferDidChangeSubject.share().eraseToAnyPublisher()
    }
    
    internal init(playerItem: AVPlayerItem) {
        self.playerItem = playerItem
        self.bufferDidChangeSubject = PassthroughSubject<Double,Never>()
        self.cancelables = Set<AnyCancellable>()
        self.startObserving()
    }
    
    private func startObserving() {
        self.playerItem
            .publisher(for: \.loadedTimeRanges)
            // do not change this queue to main, while it has unkown bug that freeze the app and main thread, suprisingly with no crash
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .map { _ in self.playerItem.bufferProgress }
            .publish(on: self.bufferDidChangeSubject)
            .store(in: &self.cancelables)
    }
}
