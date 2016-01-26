import UIKit

class MasterDetailRouter: BaseRouter {
    var detailTransitionsHandler: TransitionsHandler
    
    init(transitionsHandler: TransitionsHandler,
        detailTransitionsHandler: TransitionsHandler,
        transitionId: TransitionId?,
        parentTransitionsHandler: TransitionsHandler?)
    {
        self.detailTransitionsHandler = detailTransitionsHandler
        
        super.init(
            transitionsHandler: transitionsHandler,
            transitionId: transitionId,
            parentTransitionsHandler: parentTransitionsHandler
        )
    }
    
    final func setDetailViewControllerDerivedFrom(
        closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(closure, animator: NavigationTransitionsAnimator())
    }
    
    final func setDetailViewControllerDerivedFrom(
        closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let detailTransitionsHandler = self.detailTransitionsHandler
        
        detailTransitionsHandler.undoAllChainedTransitionsAndResetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let viewController = closure(transitionId: generatedTransitionId, transitionsHandler: detailTransitionsHandler)
            
            let context = ForwardTransitionContext(
                pushingViewController: viewController,
                targetTransitionsHandler: detailTransitionsHandler,
                animator: animator)
            
            return context
        }
    }
}
