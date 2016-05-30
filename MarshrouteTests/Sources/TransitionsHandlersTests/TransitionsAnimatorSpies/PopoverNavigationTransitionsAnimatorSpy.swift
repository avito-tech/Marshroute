enum PopoverNavigationTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: PopoverNavigationPresentationAnimationContext)
}

enum PopoverNavigationTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: PopoverNavigationDismissalAnimationContext)
}

final class PopoverNavigationTransitionsAnimatorSpy: PopoverNavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    var animatePerforming: PopoverNavigationTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: PopoverNavigationPresentationAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }
    
    var animateUndoing: PopoverNavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: PopoverNavigationDismissalAnimationContext)
    {
        animateUndoing = .Called(animationContext: context)
    }
}