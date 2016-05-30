enum ModalEndpointNavigationTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: ModalEndpointNavigationPresentationAnimationContext)
}

enum ModalEndpointNavigationTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: ModalEndpointNavigationDismissalAnimationContext)
}

final class ModalEndpointNavigationTransitionsAnimatorSpy: ModalEndpointNavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: ModalEndpointNavigationTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalEndpointNavigationPresentationAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }
    
    var animateUndoing: ModalEndpointNavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalEndpointNavigationDismissalAnimationContext)
    {
         animateUndoing = .Called(animationContext: context)
    }
}