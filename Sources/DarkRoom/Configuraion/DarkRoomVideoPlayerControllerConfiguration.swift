//
//  File.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

// MARK: - Abstraction

public protocol DarkRoomVideoPlayerControllerConfiguration {
    
    var loadingViewConfiguration: DarkRoomLoadingViewConfiguration { get }
    
    var controlViewConfiguration: DarkRoomControlViewConfiguration { get }
    
    var videoPlayerBackgroudColor: UIColor { get }
    
    var showsPlaybackControls: Bool { get }
    
    var videoContentMode: UIView.ContentMode { get }
    
    /// Amount of pan needed to dismiss the carousel.
    /// The difference is calculated by subtracting start and the end point of pan gesture.
    var dismissPanAmount: CGFloat { get }
    
    /// A smooth shadow will applied to bottom of videoPlayer with the height of 200 if set to be true
    var isBottomShadowEnabled: Bool { get }
}

// MARK: - Implementation

public struct DarkRoomVideoPlayerControllerDefaultConfiguration: DarkRoomVideoPlayerControllerConfiguration {
 
    public var loadingViewConfiguration: DarkRoomLoadingViewConfiguration
    
    public var controlViewConfiguration: DarkRoomControlViewConfiguration
    
    public var videoPlayerBackgroudColor: UIColor
    
    public var showsPlaybackControls: Bool
    
    public var videoContentMode: UIView.ContentMode
    
    public var dismissPanAmount: CGFloat
    
    public var isBottomShadowEnabled: Bool
    
    public init(
        loadingViewConfiguration: DarkRoomLoadingViewConfiguration = DarkRoomLoadingViewDefaultConfiguration(),
        controlViewConfiguration: DarkRoomControlViewConfiguration = DarkRoomControlViewDefaultConfiguration(),
        videoPlayerBackgroudColor: UIColor = .black,
        showsPlaybackControls: Bool = true,
        videoContentMode: UIView.ContentMode = .scaleAspectFit,
        dismissPanAmount: CGFloat = 70,
        isBottomShadowEnabled: Bool = true
    ) {
        self.loadingViewConfiguration = loadingViewConfiguration
        self.controlViewConfiguration = controlViewConfiguration
        self.videoPlayerBackgroudColor = videoPlayerBackgroudColor
        self.showsPlaybackControls = showsPlaybackControls
        self.videoContentMode = videoContentMode
        self.dismissPanAmount = dismissPanAmount
        self.isBottomShadowEnabled = isBottomShadowEnabled
    }
}
