enum NavigationTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: PushAnimationContext)
}

enum NavigationTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: PopAnimationContext)
}

final class NavigationTransitionsAnimatorSpy: NavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: NavigationTransitionsAnimatorSpyPerformCalls?
    
    override func animatePerformingTransition(animationContext context: PushAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }

    var animateUndoing: NavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: PopAnimationContext)
    {
        animateUndoing = .called(animationContext: context)
    }
}
