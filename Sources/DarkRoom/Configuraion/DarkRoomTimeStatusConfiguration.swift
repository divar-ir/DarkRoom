//
//  DarkRoomTimeStatusConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

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
