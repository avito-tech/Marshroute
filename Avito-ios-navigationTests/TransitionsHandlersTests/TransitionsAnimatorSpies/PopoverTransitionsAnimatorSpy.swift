enum PopoverTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: PopoverPresentationAnimationContext)
}

enum PopoverTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: PopoverDismissalAnimationContext)
}

final class PopoverTransitionsAnimatorSpy: PopoverTransitionsAnimator
{
   // MARK: - TransitionsAnimator
    
    var animatePerforming: PopoverTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: PopoverPresentationAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }
    
    var animateUndoing: PopoverTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: PopoverDismissalAnimationContext)
    {
        animateUndoing = .Called(animationContext: context)
    }
}