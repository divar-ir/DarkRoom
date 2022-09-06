//
//  DarkRoomProgressShapeLayer.swift
//
//
//  Created by Kiarash Vosough on 7/8/22.
//

import UIKit

internal final class DarkRoomLoadingShapeLayer: CAShapeLayer {

    internal init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        self.setupLayer(strokeColor: strokeColor, lineWidth: lineWidth)
    }

    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLayer(strokeColor: .clear, lineWidth: 10)
    }

    private func setupLayer(strokeColor: UIColor, lineWidth: CGFloat) {
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
}
