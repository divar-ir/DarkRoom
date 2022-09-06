//
//  DarkRoomLoadingViewConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

// MARK: - Abstraction

public protocol DarkRoomLoadingViewConfiguration {
    
    var loadingViewColors: [UIColor] { get }
    
    var loadingViewLineWidth: CGFloat { get }
    
    var loadingViewBackgroundColor: UIColor { get }
}

// MARK: - Implementation

public struct DarkRoomLoadingViewDefaultConfiguration: DarkRoomLoadingViewConfiguration {

    public var loadingViewColors: [UIColor]
    
    public var loadingViewLineWidth: CGFloat
    
    public var loadingViewBackgroundColor: UIColor
    
    public init(
        loadingViewColors: [UIColor] = [DarkRoomAsset.Colors.brandRed.color.withAlphaComponent(0.7)],
        loadingViewLineWidth: CGFloat = 10,
        loadingViewBackgroundColor: UIColor = .clear
    ) {
        self.loadingViewColors = loadingViewColors
        self.loadingViewLineWidth = loadingViewLineWidth
        self.loadingViewBackgroundColor = loadingViewBackgroundColor
    }
    
    
}
