import UIKit

protocol DetailRouter: class {
    func setDetailViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func setDetailViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
}

// MARK: - DetailRouter Default Impl
extension DetailRouter where Self: DetailRouterTransitionable, Self: RouterIdentifiable {
    func setDetailViewControllerDerivedFrom(
        @noescape closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(closure, animator: NavigationTransitionsAnimator())
    }
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        guard let detailTransitionsHandler = detailTransitionsHandler
            else { assert(false); return }        
        
        let viewController = deriveViewController(
            transitionId: transitionId,
            transitionsHandler: detailTransitionsHandler)
        
        let resetDetailContext = ForwardTransitionContext(
            resetingWithViewController: viewController,
            transitionsHandler: detailTransitionsHandler,
            animator: animator,
            transitionId: transitionId)

        detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
    }
}