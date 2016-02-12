import UIKit

protocol DetailRouter: class {
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - DetailRouter Default Impl
extension DetailRouter where Self: DetailRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder {

    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }        
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let routerSeed = BaseRouterSeed(transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)

        let resetDetailContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId)

        animatingDetailTransitionsHandler.resetWithTransition(context: resetDetailContext)
    }
}