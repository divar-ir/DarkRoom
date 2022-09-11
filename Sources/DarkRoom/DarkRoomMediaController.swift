//
//  DarkRoomMediaController.swift
//  
//
//  Created by Kiarash Vosough on 7/9/22.
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
