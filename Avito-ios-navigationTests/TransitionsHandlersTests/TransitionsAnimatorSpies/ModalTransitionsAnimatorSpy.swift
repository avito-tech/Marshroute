enum ModalTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: ModalPresentationAnimationContext)
}

enum ModalTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: ModalDismissalAnimationContext)
}

final class ModalTransitionsAnimatorSpy: ModalTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: ModalTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalPresentationAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }
    
    var animateUndoing: ModalTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalDismissalAnimationContext)
    {
        animateUndoing = .Called(animationContext: context)
    }
}