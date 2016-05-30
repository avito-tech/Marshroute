import UIKit

/// Аниматор, выполняющий модальный переход на конечный UINavigationController, 
/// например MFMailComposeViewController, UIImagePickerController.
/// Также выполняет обратный переход
public class ModalEndpointNavigationTransitionsAnimator: TransitionsAnimator
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
    public func animatePerformingTransition(animationContext context: ModalEndpointNavigationPresentationAnimationContext)
    {
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