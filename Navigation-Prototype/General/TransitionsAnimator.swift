protocol TransitionsAnimator: class {    
    func animatePerformingTransition(animationContext context: TransitionAnimationContext)
    func animateUndoingTransition(animationContext context: TransitionAnimationContext)
    func animateUndoingAllTransitions(animationContext context: TransitionAnimationContext)
}