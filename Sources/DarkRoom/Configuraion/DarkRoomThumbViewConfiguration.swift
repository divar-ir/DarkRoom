//
//  DarkRoomThumbViewConfiguration.swift
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
