//
//  ImageViewerTransitionPresentationManager.swift
//
//
//  Created by Karo Sahafi on 11/14/21.
//

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
