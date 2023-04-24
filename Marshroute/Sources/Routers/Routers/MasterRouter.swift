import UIKit

/// Роутер, работающий с двумя UINavigationController'ами, и выполняющий push- и reset-переходы в каждый из них
public protocol MasterRouter {
    func setMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController)
    
    func setMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    
    func pushMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController)
    
    func pushMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func setDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func setDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    
    func pushDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    
    func pushDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - MasterRouter Default Impl
extension MasterRouter where
    Self: MasterRouterTransitionable,
    Self: DetailRouterTransitionable,
    Self: RouterIdentifiable,
    Self: TransitionIdGeneratorHolder,
    Self: TransitionsHandlersProviderHolder,
    Self: RouterControllersProviderHolder,
    Self: RouterTransitionDelegateHoder
{
    
    public func setMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: ResetNavigationTransitionsAnimator()
        )
    }
    
    public func setMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    {
        guard let masterNavigationTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()  as? NavigationTransitionsHandler
            else { marshrouteAssertionFailure(); return }

        routerTransitionDelegate?.routerWillPerformTransitionWith(transitionId: transitionId)
        
        let masterDetailRouterSeed = MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            routerTransitionDelegate: routerTransitionDelegate
        )
        
        let viewController = deriveViewController(masterDetailRouterSeed)
        
        let resetMasterContext = ResettingTransitionContext(
            resettingRootViewController: viewController,
            navigationTransitionsHandler: masterNavigationTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        masterNavigationTransitionsHandler.resetWithTransition(context: resetMasterContext)
    }
    
    public func pushMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController)
    {
        pushMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushMasterViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let masterTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: self.masterTransitionsHandlerBox
        )

        routerTransitionDelegate?.routerWillPerformTransitionWith(transitionId: generatedTransitionId)
        
        let masterDetailRouterSeed = MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: masterTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            routerTransitionDelegate: routerTransitionDelegate
        )
        
        let viewController = deriveViewController(masterDetailRouterSeed)
        
        let pushContext = PresentationTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        masterTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
    
    public func setDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(
            deriveViewController,
            animator: ResetNavigationTransitionsAnimator()
        )
    }
    
    public func setDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: ResetNavigationTransitionsAnimator)
    {
        guard let detailNavigationTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler() as? NavigationTransitionsHandler
            else { marshrouteAssertionFailure(); return }

        routerTransitionDelegate?.routerWillPerformTransitionWith(transitionId: transitionId)
        
        let detailRouterSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            routerTransitionDelegate: routerTransitionDelegate
        )
        
        let viewController = deriveViewController(detailRouterSeed)
        
        let resetDetailContext = ResettingTransitionContext(
            resettingRootViewController: viewController,
            navigationTransitionsHandler: detailNavigationTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        detailNavigationTransitionsHandler.resetWithTransition(context: resetDetailContext)
    }
    
    public func pushDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
    {
        pushDetailViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushDetailViewControllerDerivedFrom(
        _ deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let detailTransitionsHandlerBox = transitionsHandlersProvider.topTransitionsHandlerBox(
            transitionsHandlerBox: self.detailTransitionsHandlerBox
        )

        routerTransitionDelegate?.routerWillPerformTransitionWith(transitionId: generatedTransitionId)
        
        let detailRouterSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: detailTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider,
            routerTransitionDelegate: routerTransitionDelegate
        )
        
        let viewController = deriveViewController(detailRouterSeed)
        
        let pushContext = PresentationTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        detailTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
}
