import UIKit

/// Аниматор, выполняющий модальный переход на UISplitViewController.
/// Также выполняет обратный переход
public class ModalMasterDetailTransitionsAnimator: TransitionsAnimator
{
    public var shouldAnimate = true
    
    public var sourceModalTransitionStyle: UIModalTransitionStyle
    public var sourceModalPresentationStyle: UIModalPresentationStyle
    public var targetModalTransitionStyle: UIModalTransitionStyle
    public var targetModalPresentationStyle: UIModalPresentationStyle
    
    // MARK: - Init
    
    public init(
        sourceModalTransitionStyle: UIModalTransitionStyle?,
        sourceModalPresentationStyle: UIModalPresentationStyle?,
        targetModalTransitionStyle: UIModalTransitionStyle?,
        targetModalPresentationStyle: UIModalPresentationStyle?)
    {
        self.sourceModalTransitionStyle = sourceModalTransitionStyle ?? .CoverVertical
        self.sourceModalPresentationStyle = sourceModalPresentationStyle ?? .FullScreen
        self.targetModalTransitionStyle = targetModalTransitionStyle ?? .CoverVertical
        self.targetModalPresentationStyle = targetModalPresentationStyle ?? .FullScreen
    }
    
    public init()
    {
        self.sourceModalTransitionStyle = .CoverVertical
        self.sourceModalPresentationStyle = .FullScreen
        self.targetModalTransitionStyle = .CoverVertical
        self.targetModalPresentationStyle = .FullScreen
    }
    
    // MARK: - TransitionsAnimator
    public func animatePerformingTransition(animationContext context: ModalMasterDetailPresentationAnimationContext)
    {
        context.sourceViewController.modalTransitionStyle = sourceModalTransitionStyle
        context.sourceViewController.modalPresentationStyle = sourceModalPresentationStyle
        
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