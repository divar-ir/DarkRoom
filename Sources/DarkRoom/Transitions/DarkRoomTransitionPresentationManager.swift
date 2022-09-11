//
//  ImageViewerTransitionPresentationManager.swift
//
//
//  Created by Karo Sahafi on 11/14/21.
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

/// Abstraction for PagingViewController which will be shown and its content from last page is moved with animation
public protocol DarkRoomTransitionViewControllerConvertible {

    /// The `ImageView` of presentingController which will be animated an moved to new Controller
    var sourceView: UIImageView? { get }
    
    /// The `OverlayView` of presentingController which will be animated an moved to new Controller
    var sourceOverlayView: UIImageView? { get }
    
    /// The `ImageView` of presentedController which should show the content of `sourceView`
    var targetView: UIImageView? { get }
    
    /// The `OverlayView` of presentedController which should show the content of `sourceView`
    var targetOverlayView: UIImageView? { get }
}

internal final class DarkRoomTransitionPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerView!.bounds.size
        )
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

internal final class DarkRoomTransitionPresentationManager: NSObject {}

// MARK: - UIViewControllerTransitioning Delegate

extension DarkRoomTransitionPresentationManager: UIViewControllerTransitioningDelegate {

    internal func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = DarkRoomTransitionPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        return presentationController
    }
    
    internal func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return DarkRoomTransitionPresenting()
    }
    
    internal func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return DarkRoomTransitionDismiss()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension DarkRoomTransitionPresentationManager: UIAdaptivePresentationControllerDelegate {
    
    internal func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }
    
    internal func presentationController(
        _ controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
    ) -> UIViewController? {
        return nil
    }
}
