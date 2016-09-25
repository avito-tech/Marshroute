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
extension MasterRouter where Self: MasterRouterTransitionable, Self: DetailRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsHandlersProviderHolder, Self: RouterControllersProviderHolder {
    
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
        guard let animatingMasterTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let masterDetailRouterSeed = MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(masterDetailRouterSeed)
        
        let resetMasterContext = ResettingTransitionContext(
            resettingRootViewController: viewController,
            animatingTransitionsHandler: animatingMasterTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        animatingMasterTransitionsHandler.resetWithTransition(context: resetMasterContext)
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
        
        let masterDetailRouterSeed = MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: masterTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
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
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let detailRouterSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(detailRouterSeed)
        
        let resetDetailContext = ResettingTransitionContext(
            resettingRootViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        animatingDetailTransitionsHandler.resetWithTransition(context: resetDetailContext)
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
        
        let detailRouterSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: detailTransitionsHandlerBox.unbox(),
            transitionsHandlersProvider: transitionsHandlersProvider,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
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
