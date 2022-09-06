//
//  DarkRoomRotationAnimation.swift
//
//
//  Created by Kiarash Vosough on 7/8/22.
//

import UIKit

internal final class DarkRoomRotationAnimation: CABasicAnimation {

    internal enum Direction: String {
        case x, y, z
    }

    internal override init() {
        super.init()
    }

    internal init(
        direction: Direction,
        fromValue: CGFloat,
        toValue: CGFloat,
        duration: Double,
        repeatCount: Float
    ) {
        super.init()
        self.keyPath = "transform.rotation.\(direction.rawValue)"
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.repeatCount = repeatCount
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
