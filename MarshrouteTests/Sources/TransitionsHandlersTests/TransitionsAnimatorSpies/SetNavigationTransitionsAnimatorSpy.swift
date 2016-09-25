enum SetNavigationTransitionsAnimatorSpyCalls {
    case called(animationContext: SettingNavigationAnimationContext)
}

final class SetNavigationTransitionsAnimatorSpy: SetNavigationTransitionsAnimator
{
    // MARK: - ResetTransitionsAnimator
    
    var setNavigationTransitionsAnimatorSpyCalls: SetNavigationTransitionsAnimatorSpyCalls!
    
    override func animateResettingWithTransition(animationContext context: SettingNavigationAnimationContext)
    {
        setNavigationTransitionsAnimatorSpyCalls = .called(animationContext: context)
    }
}
