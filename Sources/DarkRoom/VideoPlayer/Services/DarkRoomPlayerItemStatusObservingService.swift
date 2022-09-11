//
//  DarkRoomPlayerItemStatusObservingService.swift
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
