protocol TransitionsAnimator: class {    
    func animatePerformingTransition(animationContext context: TransitionAnimationContext)
    func animateUndoingTransition(animationContext context: TransitionAnimationContext)
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext)
}

extension TransitionsAnimator {
    func animatePerformingTransition(animationContext context: TransitionAnimationContext) {}
    func animateUndoingTransition(animationContext context: TransitionAnimationContext) {}
    func animateResettingWithTransition(animationContext context: TransitionAnimationContext) {}
}