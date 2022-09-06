//
//  DarkRoomPlayerItemStatusObservingService.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Combine

// MARK: - Abstraction

public protocol DarkRoomPlayerItemStatusObservingService: AnyObject {
    
    var statusChangePublisher: AnyPublisher<AVPlayerItem.Status, Never> { get }
}

// MARK: - Implementation

internal final class DarkRoomPlayerItemStatusObservingServiceImpl: DarkRoomPlayerItemStatusObservingService {

    // MARK: - Inputs

    private let item: AVPlayerItem
    
    // MARK: - Variables
    
    private let statusChangeSubject: CurrentValueSubject<AVPlayerItem.Status, Never>
    
    private var publisherCancelables: Set<AnyCancellable>

    // MARK: - Outputs

    internal var statusChangePublisher: AnyPublisher<AVPlayerItem.Status, Never> {
        self.statusChangeSubject
            .share()
            .eraseToAnyPublisher()
    }

    // MARK: - Init

    internal init(item: AVPlayerItem) {
        self.item = item
        self.statusChangeSubject = CurrentValueSubject<AVPlayerItem.Status, Never>(item.status)
        self.publisherCancelables = Set<AnyCancellable>()
        item.publisher(for: \.status)
            .assign(to: \.value, on: self.statusChangeSubject)
            .store(in: &self.publisherCancelables)
    }
}
