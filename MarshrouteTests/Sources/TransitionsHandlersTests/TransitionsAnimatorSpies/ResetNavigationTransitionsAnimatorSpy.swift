enum ResetNavigationTransitionsAnimatorSpyCalls {
    case called(animationContext: ResettingNavigationAnimationContext)
}

final class ResetNavigationTransitionsAnimatorSpy: ResetNavigationTransitionsAnimator
{
    // MARK: - ResetTransitionsAnimator
    
    var animateResetting: ResetNavigationTransitionsAnimatorSpyCalls?
    
    override func animateResettingWithTransition(animationContext context: ResettingNavigationAnimationContext)
    {
        animateResetting = .called(animationContext: context)
    }
}
