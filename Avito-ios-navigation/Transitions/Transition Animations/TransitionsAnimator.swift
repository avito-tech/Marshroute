public protocol TransitionsAnimator: class {
    typealias PresentationAnimationContext
    typealias DismissalAnimationContext
    
    func animatePerformingTransition(animationContext context: PresentationAnimationContext)
    func animateUndoingTransition(animationContext context: DismissalAnimationContext)
}

public protocol ResetTransitionsAnimator: class {
    typealias ResettingAnimationContext
    
    func animateResettingWithTransition(animationContext context: ResettingAnimationContext)
}