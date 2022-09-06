//
//  DarkRoomCarouselDelegate.swift
//  
//
//  Created by Karo Sahafi on 11/15/21.
//

import UIKit

/// Delegate for ``DarkRoomCarouselViewController``
public protocol DarkRoomCarouselDelegate: AnyObject {
    
    /// Notify whenever the ``DarkRoomCarouselViewController``'s current page change
    /// - Parameter index: The index of page which is on the screen
    func carousel(didSlideToIndex index: Int)
    
    /// Notify whenever the ``DarkRoomCarouselViewController``'s ``UIBarButtonItem`` is tapped
    /// - Parameters:
    ///   - item: The ``UIBarButtonItem`` which was tapped
    ///   - index: Index of the page which contains the  ``UIBarButtonItem``
    func carousel(didTapedBarButtonItem item: UIBarButtonItem, index: Int)
}

/// Optional methods
extension DarkRoomCarouselDelegate {
    
    public func carousel(didSlideToIndex index: Int) {}
    
    public func carousel(didTapedBarButtonItem item: UIBarButtonItem, index: Int) {}
}
