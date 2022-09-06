//
//  DarkRoomCarouselAbstractData.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

import UIKit

public protocol DarkRoomCarouselAbstractData {
    
    /// Provide a default image for ``DarkRoomCarouselViewController`` viewer to show placeholder
    /// in case of raising an error on loading main media.
    /// - Parameter index: The index of the media which needs placeholder.
    /// - Returns: The image which will be used as place holder until the media will be loaded.
    var imagePlaceholder: UIImage { get }
}
