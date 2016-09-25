enum ModalNavigationTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: ModalNavigationPresentationAnimationContext)
}

enum ModalNavigationTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: ModalNavigationDismissalAnimationContext)
}

final class ModalNavigationTransitionsAnimatorSpy: ModalNavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    var animatePerforming: ModalNavigationTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalNavigationPresentationAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }
    
    var animateUndoing: ModalNavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalNavigationDismissalAnimationContext)
    {
        animateUndoing = .called(animationContext: context)
    }
}
