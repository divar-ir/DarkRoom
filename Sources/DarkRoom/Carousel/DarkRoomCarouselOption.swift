//
//  DarkRoomMediaController.swift
//
//
//  Created by Kiarash Vosough on 7/9/22.
//

import UIKit

public enum DarkRoomCarouselOption {
    
    /// Set the icon to `leftBarButtonItem` of ``UINavigationItem`` which belongs to ``DarkRoomCarouselViewController``
    case closeIcon(icon: UIImage)
    
    /// Set title on new ``UIBarButtonItem`` and insert it on ``UINavigationItem`` which belongs to ``DarkRoomCarouselViewController``
    case rightNavItemTitle(title: String)
    
    /// Set icon on new ``UIBarButtonItem`` and insert it on ``UINavigationItem`` which belongs to ``DarkRoomCarouselViewController``
    case rightNavItemIcon(icon: UIImage)
}
