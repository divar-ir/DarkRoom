//
//  File.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

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
