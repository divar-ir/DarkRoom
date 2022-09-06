//
//  DarkRoomControlViewConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

// MARK: - Abstraction

public protocol DarkRoomControlViewConfiguration {
    
    var progressViewConfiguration: DarkRoomSliderViewConfiguration { get }
    
    var timeStatusConfiguration: DarkRoomTimeStatusConfiguration { get }
    
    var controlViewBackgroundColor: UIColor? { get }
    
    var playImage: UIImage { get }

    var pauseImage: UIImage { get }
    
    var errorColor: UIColor { get }
}

// MARK: - Implementation

public struct DarkRoomControlViewDefaultConfiguration: DarkRoomControlViewConfiguration {

    public var progressViewConfiguration: DarkRoomSliderViewConfiguration
    
    public var timeStatusConfiguration: DarkRoomTimeStatusConfiguration
    
    public var controlViewBackgroundColor: UIColor?
    
    public var playImage: UIImage
    
    public var pauseImage: UIImage
    
    public var errorColor: UIColor
    
    public init(
        progressViewConfiguration: DarkRoomSliderViewConfiguration = DarkRoomSliderViewDefaultConfiguration(),
        timeStatusConfiguration: DarkRoomTimeStatusConfiguration = DarkRoomTimeStatusDefaultConfiguration(),
        controlViewBackgroundColor: UIColor? = .clear,
        playImage: UIImage = DarkRoomAsset.Images.play.image!,
        pauseImage: UIImage = DarkRoomAsset.Images.pause.image!,
        errorColor: UIColor = DarkRoomAsset.Colors.brandRed.color
    ) {
        self.progressViewConfiguration = progressViewConfiguration
        self.timeStatusConfiguration = timeStatusConfiguration
        self.controlViewBackgroundColor = controlViewBackgroundColor
        self.playImage = playImage
        self.pauseImage = pauseImage
        self.errorColor = errorColor
    }    
}
