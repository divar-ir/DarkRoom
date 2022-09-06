//
//  DarkRoomStrokeAnimation.swift
//
//
//  Created by Kiarash Vosough on 7/8/22.
//

import UIKit

internal final class DarkRoomStrokeAnimation: CABasicAnimation {

    internal enum StrokeType {
        case start
        case end
    }

    internal override init() {
        super.init()
    }

    internal init(
        type: StrokeType,
        beginTime: Double = 0.0,
        fromValue: CGFloat,
        toValue: CGFloat,
        duration: Double
    ) {
        super.init()

        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
