import Foundation

final class PopoverTranstionsAnimator {}

extension PopoverTranstionsAnimator: TransitionsAnimator {
    func animatePerformingTransition(animationContext context: TransitionAnimationContext) {
        guard let context = context as? PopoverAnimationContext
            else { assert(false, "bad animation context"); return }
        
        switch context.animationStyle {
        case .PresentFromBarButtonItem(let buttonItem):
            context.popoverController.presentPopoverFromBarButtonItem(
                buttonItem,
                permittedArrowDirections: .Any,
                animated: true)
        case .PresentFromView(let sourceView, let sourceRect):
            context.popoverController.presentPopoverFromRect(
                sourceRect,
                inView: sourceView,
                permittedArrowDirections: .Any,
                animated: true)
        }
        
        // только так можно отключить кнопки на navigation bar'е из которого, вызвали поповер
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            context.popoverController.passthroughViews = nil
        })
    }
    
    func animateUndoingTransition(animationContext context: TransitionAnimationContext) {
        guard let context = context as? PopoverAnimationContext
            else { assert(false, "bad animation context"); return }
        
        context.popoverController.dismissPopoverAnimated(true)
    }
    
    func animateUndoingAllTransitions(animationContext context: TransitionAnimationContext) {
        guard let context = context as? PopoverAnimationContext
            else { assert(false, "bad animation context"); return }
        
        context.popoverController.dismissPopoverAnimated(true)
    }
    
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext) {
        assert(false, "must not be called")
    }
}
