public protocol TransitionsAnimator: class {
    associatedtype PresentationAnimationContext
    associatedtype DismissalAnimationContext
    
    func animatePerformingTransition(animationContext context: PresentationAnimationContext)
    func animateUndoingTransition(animationContext context: DismissalAnimationContext)
}

public protocol ResetTransitionsAnimator: class {
    associatedtype ResettingAnimationContext
    
    func animateResettingWithTransition(animationContext context: ResettingAnimationContext)
}
