enum ResetNavigationTransitionsAnimatorSpyCalls {
    case Called(animationContext: ResettingNavigationAnimationContext)
}

final class ResetNavigationTransitionsAnimatorSpy: ResetNavigationTransitionsAnimator
{
    // MARK: - ResetTransitionsAnimator
    
    var animateResetting: ResetNavigationTransitionsAnimatorSpyCalls?
    
    override func animateResettingWithTransition(animationContext context: ResettingNavigationAnimationContext)
    {
        animateResetting = .Called(animationContext: context)
    }
}