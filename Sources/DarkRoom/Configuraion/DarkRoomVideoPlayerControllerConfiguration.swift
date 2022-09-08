//
//  DarkRoomVideoPlayerControllerConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
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
