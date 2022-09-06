//
//  DarkRoomTransitionPresenting.swift
//  
//
//  Created by Karo Sahafi on 11/14/21.
//

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
