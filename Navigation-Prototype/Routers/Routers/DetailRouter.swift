import UIKit

protocol DetailRouter: class {
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - DetailRouter Default Impl
extension DetailRouter where Self: DetailRouterTransitionable, Self: RouterIdentifiable {
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }        
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let viewController = deriveViewController(
            transitionId: transitionId,
            transitionsHandlerBox: detailTransitionsHandlerBox)
        
        let resetDetailContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId)

        animatingDetailTransitionsHandler.resetWithTransition(context: resetDetailContext)
    }
}