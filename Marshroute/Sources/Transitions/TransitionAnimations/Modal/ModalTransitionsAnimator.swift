import UIKit

/// Аниматор, выполняющий модальный переход на UIViewController, не обернутый в UINavigationController.
/// Также выполняет обратный переход
open class ModalTransitionsAnimator: TransitionsAnimator
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
    open func animatePerformingTransition(animationContext context: ModalPresentationAnimationContext)
    {
        context.targetViewController.modalTransitionStyle = targetModalTransitionStyle
        context.targetViewController.modalPresentationStyle = targetModalPresentationStyle
        
        context.sourceViewController.present(
            context.targetViewController,
            animated: shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
    
    open func animateUndoingTransition(animationContext context: ModalDismissalAnimationContext)
    {
        context.targetViewController.dismiss(
            animated: shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
}
