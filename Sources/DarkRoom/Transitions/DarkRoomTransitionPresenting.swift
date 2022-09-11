//
//  DarkRoomTransitionPresenting.swift
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

/// Presenting Transition for cases when user demands to present  ``DarkRoomCarouselViewController``
internal final class DarkRoomTransitionPresenting: NSObject, UIViewControllerAnimatedTransitioning, DarkRoomDummyImageCreator {

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.320
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey =  .to
        guard let controller = transitionContext.viewController(forKey: key) else { return }

        guard
            let transitionVC = controller as? DarkRoomTransitionViewControllerConvertible,
            let sourceView = transitionVC.sourceView
        else { return }

        let transitionView = transitionContext.containerView
        let animationDuration = transitionDuration(using: transitionContext)

        sourceView.alpha = 0.0
        controller.view.alpha = 0.0

        transitionView.addSubview(controller.view)
        transitionVC.targetView?.alpha = 0.0

        let dummyImageView = createDummyImageView(basedOn: sourceView, overlay: transitionVC.sourceOverlayView)
        dummyImageView.contentMode = sourceView.contentMode

        transitionView.addSubview(dummyImageView)

        UIView.animate(withDuration: animationDuration, animations: {
            dummyImageView.frame = UIScreen.main.bounds
            dummyImageView.contentMode = .scaleAspectFit
            controller.view.alpha = 1.0
        }) { finished in
            transitionVC.targetView?.alpha = 1.0
            dummyImageView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}
