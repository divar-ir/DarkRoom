//
//  DarkRoomTransitionDismiss.swift
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

/// Dismiss Transition for ``DarkRoomCarouselViewController`` when user demand dismiss by tapping close button or panning
internal final class DarkRoomTransitionDismiss: NSObject, UIViewControllerAnimatedTransitioning, DarkRoomDummyImageCreator {

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.320
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }

        guard let transitionVC = controller as? DarkRoomTransitionViewControllerConvertible else { return }

        let transitionView = transitionContext.containerView
        let animationDuration = transitionDuration(using: transitionContext)

        let sourceView = transitionVC.sourceView
        let targetView = transitionVC.targetView
        
        let dummyImageView = createDummyImageView(basedOn: targetView, overlay: transitionVC.targetOverlayView)
        dummyImageView.frame = targetView?.frameRelativeToWindow() ?? UIScreen.main.bounds
        transitionView.addSubview(dummyImageView)
        targetView?.isHidden = true

        controller.view.alpha = 1.0
        UIView.animate(withDuration: animationDuration, animations: {
            if let sourceView = sourceView {
                dummyImageView.frame = sourceView.frameRelativeToWindow()
                dummyImageView.contentMode = sourceView.contentMode
            } else {
                dummyImageView.alpha = 0.0
            }
            controller.view.alpha = 0.0
        }) { finished in
            sourceView?.alpha = 1.0
            controller.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}
