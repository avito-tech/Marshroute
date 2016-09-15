enum PopoverTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: PopoverPresentationAnimationContext)
}

enum PopoverTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: PopoverDismissalAnimationContext)
}

final class PopoverTransitionsAnimatorSpy: PopoverTransitionsAnimator
{
   // MARK: - TransitionsAnimator
    
    var animatePerforming: PopoverTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: PopoverPresentationAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }
    
    var animateUndoing: PopoverTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: PopoverDismissalAnimationContext)
    {
        animateUndoing = .called(animationContext: context)
    }
}
