enum ModalNavigationTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: ModalNavigationPresentationAnimationContext)
}

enum ModalNavigationTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: ModalNavigationDismissalAnimationContext)
}

final class ModalNavigationTransitionsAnimatorSpy: ModalNavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    var animatePerforming: ModalNavigationTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalNavigationPresentationAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }
    
    var animateUndoing: ModalNavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalNavigationDismissalAnimationContext)
    {
        animateUndoing = .Called(animationContext: context)
    }
}