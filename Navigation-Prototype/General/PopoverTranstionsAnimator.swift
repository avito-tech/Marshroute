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
    
    func animateResettingWithTransition(_ context: TransitionAnimationContext) {
        assert(false, "must not be called")
    }
}
