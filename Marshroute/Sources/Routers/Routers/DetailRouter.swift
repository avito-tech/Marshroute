import UIKit

/// Роутер, работающий с одним UINavigationController'ом, и выполняющий push- и reset-переходы
public protocol DetailRouter: class {
    func setViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func setViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    
    func pushViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func pushViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - DetailRouter Default Impl
extension DetailRouter where Self: DetailRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsHandlersProviderHolder, Self: RouterControllersProviderHolder {
    
    public func setViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        setViewControllerDerivedFrom(
            deriveViewController,
            animator: ResetNavigationTransitionsAnimator()
        )
    }
    
    public func setViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    {
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            resettingRootViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        animatingDetailTransitionsHandler.resetWithTransition(context: resetContext)
    }
    
    public func pushViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let detailTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: self.detailTransitionsHandlerBox
        )
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: detailTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed)
        
        let pushContext = PresentationTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        detailTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
}
