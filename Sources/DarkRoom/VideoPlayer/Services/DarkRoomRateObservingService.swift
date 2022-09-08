//
//  DarkRoomRateObservingService.swift
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

public protocol DarkRoomRateObservingService {
    
    var playingEventPublisher: AnyPublisher<Void,Never> { get }

    var timeoutEventPublisher: AnyPublisher<Void,Never> { get }

    func start()
    
    func stop(clearCallbacks: Bool)
}

// MARK: - Implementation

internal final class DarkRoomRateObservingServiceImpl: DarkRoomRateObservingService {
    
    // MARK: - Inputs
    
    private let item: AVPlayerItem
    
    private let enoughDurationForPlaying: Double
    
    private let timeInterval: TimeInterval
    
    private let timeout: TimeInterval
    
    private let timerFactory: DarkRoomTimerFactory
    
    // MARK: - Variables
    
    private var cancelables: Set<AnyCancellable>
    
    internal var playingEventSubject: PassthroughSubject<Void,Never>
    
    internal var timeoutEventSubject: PassthroughSubject<Void,Never>

    // MARK: - Outputs
    
    internal var playingEventPublisher: AnyPublisher<Void,Never> { playingEventSubject.eraseToAnyPublisher() }
    
    internal var timeoutEventPublisher: AnyPublisher<Void,Never> { timeoutEventSubject.eraseToAnyPublisher() }
    
    // MARK: - Variables
    
    private weak var timer: DarkRoomPlayerTimer?

    private var remainingTime: TimeInterval

    // MARK: - Lifecycle
    
    internal init(
        config: DarkRoomPlayerConfiguration,
        item: AVPlayerItem,
        timerFactory: DarkRoomTimerFactory = DarkRoomPlayerTimerFactoryImpl()
    ) {
        self.cancelables = Set<AnyCancellable>()
        self.playingEventSubject = PassthroughSubject<Void,Never>()
        self.timeoutEventSubject = PassthroughSubject<Void,Never>()
        
        self.timeInterval = config.rateObservingTickTime
        self.timeout = config.rateObservingTimeout
        self.enoughDurationForPlaying = config.enoughDurationForPlaying
        self.timerFactory = timerFactory
        self.item = item
        self.remainingTime = 0
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Rate Service
    
    internal func start() {
        self.remainingTime = timeout
        self.timer?.invalidate()
        self.timer = self.timerFactory
            .generateTimer(
                timeInterval: self.timeInterval,
                repeats: true,
                block: self.blockTimer
            )
    }
    
    internal func stop(clearCallbacks: Bool) {
        if clearCallbacks {
            self.stopPublisher()
            
        }
        timer?.invalidate()
        timer = nil
    }
    
    private func stopPublisher() {
        playingEventSubject.send(completion: .finished)
        timeoutEventSubject.send(completion: .finished)
    }
    
    private func blockTimer() {
        
        guard let timebase = item.timebase else { return }
        
        remainingTime -= timeInterval
        let rate = CMTimebaseGetRate(timebase)
        
        if rate != 0 {
            timer?.invalidate()
            playingEventSubject.send()
        } else if remainingTime <= 0 {
            timer?.invalidate()
            self.timeoutEventSubject.send()
        } else {}
    }
}
