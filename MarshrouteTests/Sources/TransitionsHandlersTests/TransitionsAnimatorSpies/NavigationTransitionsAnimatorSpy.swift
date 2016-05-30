enum NavigationTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: PushAnimationContext)
}

enum NavigationTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: PopAnimationContext)
}

final class NavigationTransitionsAnimatorSpy: NavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: NavigationTransitionsAnimatorSpyPerformCalls?
    
    override func animatePerformingTransition(animationContext context: PushAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }

    var animateUndoing: NavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: PopAnimationContext)
    {
        animateUndoing = .Called(animationContext: context)
    }
}