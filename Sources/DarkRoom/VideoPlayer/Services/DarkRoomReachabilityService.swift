//
//  DarkRoomReachabilityService.swift
//  
//
//  Created by Kiarash Vosough on 7/13/22.
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

import Foundation
import Combine
import Network

// MARK: - Abstraction

public protocol DarkRoomReachabilityService {

    var isReachable: AnyPublisher<Bool, Never> { get }

    var isTimedOut: AnyPublisher<Void, Never> { get }

    func start()
}

// MARK: - Implementation

internal final class DarkRoomReachabilityServiceImpl: DarkRoomReachabilityService {

    // MARK: - Inputs

    private var timeoutURLSession: TimeInterval

    private let tiNetworkTesting: TimeInterval

    private let timerFactory: DarkRoomTimerFactory

    // MARK: - Outputs

    internal var isReachable: AnyPublisher<Bool, Never> { reachableSubject.share().eraseToAnyPublisher() }

    internal var isTimedOut: AnyPublisher<Void, Never> { timeoutSubject.share().eraseToAnyPublisher() }
    
    // MARK: - Variables
    
    private var monitor = NWPathMonitor()
    private let reachableSubject: PassthroughSubject<Bool, Never>
    private let timeoutSubject: PassthroughSubject<Void, Never>
    
    private var timer: DarkRoomPlayerTimer? {
        didSet { timer?.fire() }
    }
    // MARK: - Init

    internal init(
        config: DarkRoomPlayerConfiguration,
        timerFactory: DarkRoomTimerFactory = DarkRoomPlayerTimerFactoryImpl()
    ) {
        self.timerFactory = timerFactory
        self.timeoutURLSession = config.reachabilityURLSessionTimeout
        self.tiNetworkTesting = config.reachabilityNetworkTestingTickTime
        self.reachableSubject = PassthroughSubject<Bool, Never>()
        self.timeoutSubject = PassthroughSubject<Void, Never>()
    }

    deinit {
        monitor.cancel()
    }

    // MARK: - Session & Task

    internal func start() {
        monitor.start(queue: .global(qos: .default))
        monitor.pathUpdateHandler = { [weak self] path in
            guard let strongSelf = self else { return }
            switch path.status {
            case .satisfied: strongSelf.reachableSubject.send(true)
            case .unsatisfied, .requiresConnection: strongSelf.reachableSubject.send(false)
            @unknown default: break
            }
        }
        
        timer = timerFactory.generateTimer(timeInterval: tiNetworkTesting, repeats: true) { [weak self] in
            guard let strongSelf = self else { return }
            
            guard strongSelf.timeoutURLSession > 0 else {
                strongSelf.monitor.cancel()
                strongSelf.timeoutSubject.send()
                return
            }
            strongSelf.timeoutURLSession -= strongSelf.tiNetworkTesting
        }
    }
}
