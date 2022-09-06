//
//  DarkRoomImageControllerConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

public protocol DarkRoomImageControllerConfiguration {
    
    var backgrountColor: UIColor { get }
    
    var dismissPanAmount: CGFloat { get }
}

public struct DarkRoomImageControllerDeafultConfiguration: DarkRoomImageControllerConfiguration {
    
    public var backgrountColor: UIColor
    
    public var dismissPanAmount: CGFloat
    
    public init(
        backgrountColor: UIColor = .clear,
        dismissPanAmount: CGFloat = 70
    ) {
        self.backgrountColor = backgrountColor
        self.dismissPanAmount = dismissPanAmount
    }
}
