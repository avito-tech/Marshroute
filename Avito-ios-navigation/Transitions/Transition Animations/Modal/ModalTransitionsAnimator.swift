import UIKit

public class ModalTransitionsAnimator: TransitionsAnimator
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
    
    // MARK: - TransitionsAnimator
    public func animatePerformingTransition(animationContext context: ModalPresentationAnimationContext)
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
    
    public func animateUndoingTransition(animationContext context: ModalDismissalAnimationContext)
    {
        context.targetViewController.dismissViewControllerAnimated(
            shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
}