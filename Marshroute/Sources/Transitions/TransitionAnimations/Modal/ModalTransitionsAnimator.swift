import UIKit

/// Аниматор, выполняющий модальный переход на UIViewController, не обернутый в UINavigationController.
/// Также выполняет обратный переход
public class ModalTransitionsAnimator: TransitionsAnimator
{
    public var shouldAnimate = true
    
    public var targetModalTransitionStyle: UIModalTransitionStyle
    public var targetModalPresentationStyle: UIModalPresentationStyle
    
    // MARK: - Init
    public init(
        targetModalTransitionStyle: UIModalTransitionStyle?,
        targetModalPresentationStyle: UIModalPresentationStyle?)
    {
        self.targetModalTransitionStyle = targetModalTransitionStyle ?? .CoverVertical
        self.targetModalPresentationStyle = targetModalPresentationStyle ?? .FullScreen
    }
    
    public init()
    {
        self.targetModalTransitionStyle = .CoverVertical
        self.targetModalPresentationStyle = .FullScreen
    }
    
    // MARK: - TransitionsAnimator
    public func animatePerformingTransition(animationContext context: ModalPresentationAnimationContext)
    {
        context.targetViewController.modalTransitionStyle = targetModalTransitionStyle
        context.targetViewController.modalPresentationStyle = targetModalPresentationStyle
        
        context.sourceViewController.presentViewController(
            context.targetViewController,
            animated: shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
    
    public func animateUndoingTransition(animationContext context: ModalDismissalAnimationContext)
    {
        context.targetViewController.dismissViewControllerAnimated(
            shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
}