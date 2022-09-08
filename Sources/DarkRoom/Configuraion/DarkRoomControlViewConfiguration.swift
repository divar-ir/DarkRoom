//
//  DarkRoomControlViewConfiguration.swift
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
