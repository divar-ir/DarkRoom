//
//  DarkRoomProgressViewConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

// MARK: - Abstraction

public protocol DarkRoomSliderViewConfiguration {
    
    var thumbViewConfiguration: DarkRoomThumbViewConfiguration { get }
    
    var progressBarBackgroundColor: UIColor? { get }
    
    var primaryProgressColor: UIColor? { get }
    
    var secondaryProgressColor: UIColor? { get }
    
    var progressBarHeight: CGFloat { get }
    
    var errorColor: UIColor { get }
}

// MARK: - Implementation

public struct DarkRoomSliderViewDefaultConfiguration: DarkRoomSliderViewConfiguration {
    
    public var thumbViewConfiguration: DarkRoomThumbViewConfiguration
    
    public var progressBarBackgroundColor: UIColor?
    
    public var primaryProgressColor: UIColor?
    
    public var secondaryProgressColor: UIColor?

    public var progressBarHeight: CGFloat
    
    public var errorColor: UIColor
    
    public init(
        thumbViewConfiguration: DarkRoomThumbViewConfiguration = DarkRoomThumbViewDefaultConfiguration(),
        progressBarBackgroundColor: UIColor? = DarkRoomAsset.Colors.whiteHint.color.withAlphaComponent(0.5),
        primaryProgressColor: UIColor? = DarkRoomAsset.Colors.primaryWhite.color,
        secondaryProgressColor: UIColor? = DarkRoomAsset.Colors.whiteHint.color.withAlphaComponent(0.5),
        progressBarHeight: CGFloat = 6,
        errorColor: UIColor = DarkRoomAsset.Colors.brandRed.color
    ) {
        self.thumbViewConfiguration = thumbViewConfiguration
        self.progressBarBackgroundColor = progressBarBackgroundColor
        self.primaryProgressColor = primaryProgressColor
        self.secondaryProgressColor = secondaryProgressColor
        self.progressBarHeight = progressBarHeight
        self.errorColor = errorColor
    }
}
