//
//  DarkRoomTimeStatusConfiguration.swift
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

public protocol DarkRoomTimeStatusFormatter {
    func format(currentTime: Double, totalTime: Double) -> String
}

public protocol DarkRoomTimeStatusConfiguration {
    
    /// The Initial text which is shown on time sttaus label before the video time is loaded
    var initialText: String { get }
    
    var timeStatusLabelTextColor: UIColor { get }
    
    var timeStatusLabelFont: UIFont { get }
    
    /// Formatter for time status label
    var timeFormatter: DarkRoomTimeStatusFormatter { get }
}

// MARK: - Implementation

public struct DarkRoomDefaultTimeStatusFormatter: DarkRoomTimeStatusFormatter {

    public init() {}
    
    public func format(currentTime: Double, totalTime: Double) -> String {
        let leftSeconds = Int(totalTime - currentTime)
        return String(format: "%02d:%02d", leftSeconds / 60, leftSeconds % 60)
    }
}

public struct DarkRoomTimeStatusDefaultConfiguration: DarkRoomTimeStatusConfiguration {

    public var initialText: String
    
    public var timeStatusLabelTextColor: UIColor
    
    public var timeStatusLabelFont: UIFont
    
    public var timeFormatter: DarkRoomTimeStatusFormatter
    
    public init(
        initialText: String = "00:00",
        timeStatusLabelTextColor: UIColor = .white,
        timeStatusLabelFont: UIFont = .boldSystemFont(ofSize: 15),
        timeFormatter: DarkRoomTimeStatusFormatter = DarkRoomDefaultTimeStatusFormatter()
    ) {
        self.initialText = initialText
        self.timeStatusLabelTextColor = timeStatusLabelTextColor
        self.timeStatusLabelFont = timeStatusLabelFont
        self.timeFormatter = timeFormatter
    }
}
