@testable import Marshroute

enum ModalEndpointNavigationTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: ModalEndpointNavigationPresentationAnimationContext)
}

enum ModalEndpointNavigationTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: ModalEndpointNavigationDismissalAnimationContext)
}

final class ModalEndpointNavigationTransitionsAnimatorSpy: ModalEndpointNavigationTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: ModalEndpointNavigationTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalEndpointNavigationPresentationAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }
    
    var animateUndoing: ModalEndpointNavigationTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalEndpointNavigationDismissalAnimationContext)
    {
         animateUndoing = .called(animationContext: context)
    }
}
