@testable import Marshroute

enum PopoverNavigationTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: PopoverNavigationPresentationAnimationContext)
}

enum PopoverNavigationTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: PopoverNavigationDismissalAnimationContext)
}

final class PopoverNavigationTransitionsAnimatorSpy: PopoverNavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    var animatePerforming: PopoverNavigationTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: PopoverNavigationPresentationAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }
    
    var animateUndoing: PopoverNavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: PopoverNavigationDismissalAnimationContext)
    {
        animateUndoing = .called(animationContext: context)
    }
}
