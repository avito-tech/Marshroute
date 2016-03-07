import UIKit

public protocol MasterRouter {
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController)
    
    func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func pushMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController)
    
    func pushMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func pushDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func pushDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
}

// MARK: - MasterRouter Default Impl
extension MasterRouter where Self: MasterRouterTransitionable, Self: DetailRouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder, Self: RouterControllersProviderHolder {
    
    public func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController)
    {
        setMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func setMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let masterTransitionsHandlerBox = masterTransitionsHandlerBox
            else { assert(false); return }
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        guard let animatingMasterTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let masterDetailRouterSeed = MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: masterDetailRouterSeed)
        
        let resetMasterContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingMasterTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        animatingMasterTransitionsHandler.resetWithTransition(context: resetMasterContext)
    }
    
    public func pushMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController)
    {
        pushMasterViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushMasterViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let masterTransitionsHandlerBox = masterTransitionsHandlerBox
            else { assert(false); return }
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let masterDetailRouterSeed = MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: masterTransitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: masterDetailRouterSeed)
        
        let pushContext = ForwardTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        masterTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
    
    public func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        setDetailViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func setDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        guard let animatingDetailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { assert(false); return }
        
        let detailRouterSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: detailRouterSeed)
        
        let resetDetailContext = ForwardTransitionContext(
            resettingWithViewController: viewController,
            animatingTransitionsHandler: animatingDetailTransitionsHandler,
            animator: animator,
            transitionId: transitionId
        )
        
        animatingDetailTransitionsHandler.resetWithTransition(context: resetDetailContext)
    }
    
    public func pushDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        pushDetailViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func pushDetailViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let detailTransitionsHandlerBox = detailTransitionsHandlerBox
            else { assert(false); return }
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let detailRouterSeed = RouterSeed(
            transitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: detailTransitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: detailRouterSeed)
        
        let pushContext = ForwardTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        detailTransitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
}