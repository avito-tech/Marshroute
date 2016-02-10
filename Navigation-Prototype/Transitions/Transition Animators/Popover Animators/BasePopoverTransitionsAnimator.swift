// Базовый класс для аниматоров с участием UIPopoverController
class BasePopoverTransitionsAnimator: TransitionsAnimator {
    func animatePerformingTransition(animationContext context: PopoverAnimationContext)
    {
        assert(false, "must be overriden")
    }
    
    func animateUndoingTransition(animationContext context: PopoverAnimationContext)
    {
        assert(false, "must be overriden")
    }
    
    func animateResettingWithTransition(animationContext context: PopoverAnimationContext)
    {
        assert(false, "must never be called")
    }
}