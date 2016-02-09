protocol PopoverTransitionsAnimator: class {
    func animatePerformingPopoverTransition(animationContext context: PopoverAnimationContext)
    func animateUndoingPopoverTransition(animationContext context: PopoverAnimationContext)
    func animateResettingWithPopoverTransition(animationContext context: PopoverAnimationContext)
}