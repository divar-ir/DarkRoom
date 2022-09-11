//
//  DarkRoomProgressViewConfiguration.swift
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
