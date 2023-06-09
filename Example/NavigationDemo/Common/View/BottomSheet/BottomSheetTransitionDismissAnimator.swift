import UIKit

final class BottomSheetTransitionDismissAnimator: BottomSheetTransitionAnimator {
    
    // MARK: - Properties -
    var useLinearAnimation = false
    
    // MARK: - BottomSheetTransitionAnimator -
    override func animateTransition(
        transitionContext: UIViewControllerContextTransitioning,
        sourceView: UIView,
        targetView: UIView,
        container: UIView)
    {
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: useLinearAnimation ? [.curveLinear] : [.curveEaseInOut],
            animations: { },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning -
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
}
