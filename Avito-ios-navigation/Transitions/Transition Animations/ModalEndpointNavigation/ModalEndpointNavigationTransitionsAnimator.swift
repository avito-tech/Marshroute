import UIKit

public class ModalEndpointNavigationTransitionsAnimator: TransitionsAnimator
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
    public func animatePerformingTransition(animationContext context: ModalEndpointNavigationPresentationAnimationContext)
    {
        context.sourceViewController.modalTransitionStyle = sourceModalTransitionStyle
        context.sourceViewController.modalPresentationStyle = sourceModalPresentationStyle
        
        context.targetNavigationController.modalTransitionStyle = targetModalTransitionStyle
        context.targetNavigationController.modalPresentationStyle = targetModalPresentationStyle
        
        context.sourceViewController.presentViewController(
            context.targetNavigationController,
            animated: shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
    
    public func animateUndoingTransition(animationContext context: ModalEndpointNavigationDismissalAnimationContext)
    {
        context.targetViewController.dismissViewControllerAnimated(
            shouldAnimate,
            completion: nil
        )
        shouldAnimate = true
    }
}