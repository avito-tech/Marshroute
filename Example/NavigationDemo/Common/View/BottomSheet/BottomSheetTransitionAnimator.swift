import UIKit

class BottomSheetTransitionAnimator:
    NSObject,
    BottomSheetHeightProvider,
    UIViewControllerAnimatedTransitioning
{
    // MARK: - BottomSheetHeightProvider -
    // Default implementation used if target View Controller does not conform to BottomSheetHeightProvider
    func bottomSheetHeight(forContainerSize containerSize: CGSize) -> CGFloat {
        return containerSize.height * 0.4
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning -
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let targetViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to
            ) else { return }
        guard let sourceViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from
            ) else { return }

        animateTransition(
            transitionContext: transitionContext,
            sourceView: sourceViewController.view,
            targetView: targetViewController.view,
            container: transitionContext.containerView
        )
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
    }
    
    // MARK: - BottomSheetTransitionAnimator -
    func animateTransition(
        transitionContext: UIViewControllerContextTransitioning,
        sourceView: UIView,
        targetView: UIView,
        container: UIView)
    {
        // To be overridden
    }
}
