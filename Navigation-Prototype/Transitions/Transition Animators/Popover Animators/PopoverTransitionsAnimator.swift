import Foundation

class PopoverTransitionsAnimator: TransitionsAnimator {
    func animatePerformingTransition(animationContext context: PopoverAnimationContext)
    {
        switch context.transitionStyle {
        case .PopoverFromBarButtonItem(let buttonItem):
            context.popoverController.presentPopoverFromBarButtonItem(
                buttonItem,
                permittedArrowDirections: .Any,
                animated: true)
            
        case .PopoverFromView(let sourceView, let sourceRect):
            context.popoverController.presentPopoverFromRect(
                sourceRect,
                inView: sourceView,
                permittedArrowDirections: .Any,
                animated: true)
        }
        
        // только так можно отключить кнопки на navigation bar'е из которого, вызвали поповер
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            context.popoverController.passthroughViews = nil
        })
    }
    
    func animateUndoingTransition(animationContext context: PopoverAnimationContext)
    {
        context.popoverController.dismissPopoverAnimated(true)
    }
    
    func animateResettingWithTransition(animationContext context: PopoverAnimationContext)
    {
        assert(false, "must not be called")
    }
}