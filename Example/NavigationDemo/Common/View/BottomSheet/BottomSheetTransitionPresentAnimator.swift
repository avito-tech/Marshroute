import UIKit

final class BottomSheetTransitionPresentAnimator: BottomSheetTransitionAnimator {
    
    // MARK: - BottomSheetTransitionAnimator -
    override func animateTransition(
        transitionContext: UIViewControllerContextTransitioning,
        sourceView: UIView,
        targetView: UIView,
        container: UIView)
    {
        container.addSubview(targetView)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
