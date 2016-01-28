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
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(closure, animator: NavigationTransitionsAnimator())
    }
    
    final func setDetailViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        detailTransitionsHandler.resetWithTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let viewController = closure(transitionId: generatedTransitionId, transitionsHandler: detailTransitionsHandler)
            
            let resetDetailContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: self.detailTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId
            )
            
            return resetDetailContext
        }
    }
}
