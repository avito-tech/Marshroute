public protocol TransitionsAnimator: AnyObject {
    associatedtype PresentationAnimationContext
    associatedtype DismissalAnimationContext
    
    func animatePerformingTransition(animationContext context: PresentationAnimationContext)
    func animateUndoingTransition(animationContext context: DismissalAnimationContext)
}

public protocol ResetTransitionsAnimator: AnyObject {
    associatedtype ResettingAnimationContext
    
    func animateResettingWithTransition(animationContext context: ResettingAnimationContext)
}
