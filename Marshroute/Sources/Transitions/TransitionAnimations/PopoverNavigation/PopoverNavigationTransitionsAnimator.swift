import Foundation

/// Аниматор, показывающий UIPopoverController, с UIViewController'ом, обернутым в UINavigationController.
/// Также выполняет обратный переход
open class PopoverNavigationTransitionsAnimator: TransitionsAnimator
{
    open var shouldAnimate = true
    
    // MARK: - Init
    public init() {}
    
    // MARK: - TransitionsAnimator
    open func animatePerformingTransition(animationContext context: PopoverNavigationPresentationAnimationContext)
    {
        switch context.transitionStyle {
        case .popoverFromBarButtonItem(let buttonItem):
            context.popoverController.present(
                from: buttonItem,
                permittedArrowDirections: .any,
                animated: shouldAnimate
            )
            
        case .popoverFromView(let sourceView, let sourceRect):
            context.popoverController.present(
                from: sourceRect,
                in: sourceView,
                permittedArrowDirections: .any,
                animated: shouldAnimate
            )
        }
        
        // только так можно отключить кнопки на navigation bar'е из которого, вызвали поповер
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            context.popoverController.passthroughViews = nil
        })
        
        shouldAnimate = true
    }
    
    open func animateUndoingTransition(animationContext context: PopoverNavigationDismissalAnimationContext)
    {
        context.popoverController.dismiss(
            animated: shouldAnimate
        )
        
        shouldAnimate = true
    }
}
