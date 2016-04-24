enum SetNavigationTransitionsAnimatorSpyCalls {
    case Called(animationContext: SettingNavigationAnimationContext)
}

final class SetNavigationTransitionsAnimatorSpy: SetNavigationTransitionsAnimator
{
    // MARK: - ResetTransitionsAnimator
    
    var setNavigationTransitionsAnimatorSpyCalls: SetNavigationTransitionsAnimatorSpyCalls!
    
    override func animateResettingWithTransition(animationContext context: SettingNavigationAnimationContext)
    {
        setNavigationTransitionsAnimatorSpyCalls = .Called(animationContext: context)
    }
}