enum ModalMasterDetailTransitionsAnimatorSpyPerformCalls {
    case called(animationContext: ModalMasterDetailPresentationAnimationContext)
}

enum ModalMasterDetailTransitionsAnimatorSpyUndoCalls {
    case called(animationContext: ModalMasterDetailDismissalAnimationContext)
}

final class ModalMasterDetailTransitionsAnimatorSpy: ModalMasterDetailTransitionsAnimator
{
    // MARK: - TransitionsAnimator
    
    var animatePerforming: ModalMasterDetailTransitionsAnimatorSpyPerformCalls!
    
    override func animatePerformingTransition(animationContext context: ModalMasterDetailPresentationAnimationContext)
    {
        animatePerforming = .called(animationContext: context)
    }
    
    var animateUndoing: ModalMasterDetailTransitionsAnimatorSpyUndoCalls!
    
    override func animateUndoingTransition(animationContext context: ModalMasterDetailDismissalAnimationContext)
    {
        animateUndoing = .called(animationContext: context)
    }
}
