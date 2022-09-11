//
//  DarkRoomBufferObserverService.swift
//  
//
//  Created by Kiarash Vosough on 7/16/22.
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
