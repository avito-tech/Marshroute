protocol TransitionsAnimator: class {
    typealias AnimationContext
    
    func animatePerformingTransition(animationContext context: AnimationContext)
    func animateUndoingTransition(animationContext context: AnimationContext)
    func animateResettingWithTransition(animationContext context: AnimationContext)
}