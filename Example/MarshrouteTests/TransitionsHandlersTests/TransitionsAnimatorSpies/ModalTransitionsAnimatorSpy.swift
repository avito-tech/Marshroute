@testable import Marshroute

enum ModalTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: ModalPresentationAnimationContext)
}

enum ModalTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: ModalDismissalAnimationContext)
}

final class ModalTransitionsAnimatorSpy: ModalTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: ModalTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalPresentationAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }
    
    var animateUndoing: ModalTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalDismissalAnimationContext)
    {
        animateUndoing = .called(animationContext: context)
    }
}
