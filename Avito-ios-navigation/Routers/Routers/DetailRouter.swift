import UIKit

public protocol DetailRouter: class {
    func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - DetailRouter Default Impl
extension DetailRouter where Self: DetailRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder {
    
    public func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        setViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func setViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let routerSeed = BaseRouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        let resetContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId)
        
        animatingDetailTransitionsHandler.resetWithTransition(context: resetContext)
    }
    
    public func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = BaseRouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: detailTransitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        let pushContext = ForwardTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId)
        
        detailTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
}