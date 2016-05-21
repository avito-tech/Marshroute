import UIKit

/// Аниматор, выполняющий модальный переход на UISplitViewController.
/// Также выполняет обратный переход
public class ModalMasterDetailTransitionsAnimator: TransitionsAnimator
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
    public func animatePerformingTransition(animationContext context: ModalMasterDetailPresentationAnimationContext)
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
    
    public func animateUndoingTransition(animationContext context: ModalMasterDetailDismissalAnimationContext)
    {
        context.targetViewController.dismissViewControllerAnimated(
            shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
}