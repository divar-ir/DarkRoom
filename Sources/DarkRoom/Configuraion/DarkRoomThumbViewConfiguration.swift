//
//  File.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import Foundation
import UIKit

// MARK: - Abstraction

public protocol DarkRoomThumbViewConfiguration {

    var thumbStyle: DarkRoomPlayerSliderThumbViewStyle { get }
    
    var errorColor: UIColor { get }
}

// MARK: - Implementation

public struct DarkRoomThumbViewDefaultConfiguration: DarkRoomThumbViewConfiguration {
    
    public var thumbStyle: DarkRoomPlayerSliderThumbViewStyle
    public var errorColor: UIColor
    
    public init(
        thumbStyle: DarkRoomPlayerSliderThumbViewStyle = .circleShape(radius: 20, color: DarkRoomAsset.Colors.primaryWhite.color),
        errorColor: UIColor = DarkRoomAsset.Colors.brandRed.color
    ) {
        self.thumbStyle = thumbStyle
        self.errorColor = errorColor
    }
}
