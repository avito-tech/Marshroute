import UIKit

protocol MasterRouter: class {
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - MasterRouter Default Impl
extension MasterRouter where Self: MasterRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder {
    
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let masterTransitionsHandlerBox = masterTransitionsHandlerBox
            else { assert(false); return }
        guard let animatingMasterTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let routerSeed = BaseRouterSeed(transitionsHandlerBox: masterTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        let resetMasterContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingMasterTransitionsHandler,
            animator: animator,
            transitionId: transitionId)
        
        animatingMasterTransitionsHandler.resetWithTransition(context: resetMasterContext)
    }
}