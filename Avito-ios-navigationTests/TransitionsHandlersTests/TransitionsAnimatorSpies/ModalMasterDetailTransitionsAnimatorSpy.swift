enum ModalMasterDetailTransitionsAnimatorSpyPerformCalls {
    case Called(animationContext: ModalMasterDetailPresentationAnimationContext)
}

enum ModalMasterDetailTransitionsAnimatorSpyUndoCalls {
    case Called(animationContext: ModalMasterDetailDismissalAnimationContext)
}

final class ModalMasterDetailTransitionsAnimatorSpy: ModalMasterDetailTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: ModalMasterDetailTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalMasterDetailPresentationAnimationContext)
    {
        animatePerforming = .Called(animationContext: context)
    }
    
    var animateUndoing: ModalMasterDetailTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalMasterDetailDismissalAnimationContext)
    {
        animateUndoing = .Called(animationContext: context)
    }
}