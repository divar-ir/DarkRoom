//
//  File.swift
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

import Foundation

// MARK: - Abstraction

public protocol DarkRoomPlayerTimer: AnyObject {
    func fire()
    func invalidate()
}

extension Timer: DarkRoomPlayerTimer { }

public protocol DarkRoomTimerFactory {
    func generateTimer(timeInterval: TimeInterval, repeats: Bool, block: @escaping () -> Void) -> DarkRoomPlayerTimer
}


// MARK: - Implementation

public struct DarkRoomPlayerTimerFactoryImpl: DarkRoomTimerFactory {
    
    private final class TimerAdapter: DarkRoomPlayerTimer {
        
        private let block: (() -> Void)?
        private let repeats: Bool
        private let timeInterval: TimeInterval
        private lazy var innerTimer: DarkRoomPlayerTimer = {
            Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(executeBlock), userInfo: nil, repeats: repeats)
        }()
        
        init(timeInterval: TimeInterval, repeats: Bool, block: @escaping () -> Void) {
            self.block = block
            self.repeats = repeats
            self.timeInterval = timeInterval
            innerTimer.fire()
        }
        
        @objc
        func executeBlock() {
            block?()
        }
        
        func fire() {
            innerTimer.fire()
        }
        
        func invalidate() {
            innerTimer.invalidate()
        }
    }
    
    public init() {}

    public func generateTimer(timeInterval: TimeInterval, repeats: Bool, block: @escaping () -> Void) -> DarkRoomPlayerTimer {
        return TimerAdapter(timeInterval: timeInterval, repeats: repeats, block: block)
    }
}
