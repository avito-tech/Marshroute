import UIKit

/// Аниматор, выполняющий модальный переход на UIViewController, обернутый в UINavigationController.
/// Также выполняет обратный переход
open class ModalNavigationTransitionsAnimator: TransitionsAnimator
{
    open var shouldAnimate = true
    
    open var targetModalTransitionStyle: UIModalTransitionStyle
    open var targetModalPresentationStyle: UIModalPresentationStyle
    
    // MARK: - Init
    public init(
        targetModalTransitionStyle: UIModalTransitionStyle?,
        targetModalPresentationStyle: UIModalPresentationStyle?)
    {
        self.targetModalTransitionStyle = targetModalTransitionStyle ?? .coverVertical
        self.targetModalPresentationStyle = targetModalPresentationStyle ?? .fullScreen
    }
    
    public init()
    {
        self.targetModalTransitionStyle = .coverVertical
        self.targetModalPresentationStyle = .fullScreen
    }
    
    // MARK: - TransitionsAnimator
    open func animatePerformingTransition(animationContext context: ModalNavigationPresentationAnimationContext)
    {
        context.targetNavigationController.modalTransitionStyle = targetModalTransitionStyle
        context.targetNavigationController.modalPresentationStyle = targetModalPresentationStyle
        
        context.sourceViewController.present(
            context.targetNavigationController,
            animated: shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
    
    open func animateUndoingTransition(animationContext context: ModalNavigationDismissalAnimationContext)
    {
        context.targetViewController.dismiss(
            animated: shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
}
