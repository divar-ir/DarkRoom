//
//  DarkRoomMediaController.swift
//  
//
//  Created by Kiarash Vosough on 7/9/22.
//

import UIKit

/// Abstraction for controller which are contained inside ``DarkRoomCarouselViewController`` to handle transitioning and have control over events
public protocol DarkRoomMediaController: AnyObject {
    
    /// The imageView which is used to animate transition to/from another controller
    var imageView: UIImageView { get }
    
    /// The imageOverlayView which is used to animate transition to/from another controller
    /// On presenting cases, the overlay will be placed on top of the `imageView` on presented MediaController.
    /// Work only for video media
    var imageOverlayView: UIImageView? { get }
    
    /// The index of controller inside ``DarkRoomCarouselViewController``
    var index: Int { get }
    
    /// Notify whenever the ``DarkRoomCarouselViewController`` is being dismissed
    func prepareForDismiss()
}
