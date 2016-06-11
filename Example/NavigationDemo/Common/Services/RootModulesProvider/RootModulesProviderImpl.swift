import Marshroute

final class RootModulesProviderImpl: RootModulesProvider {
    func detailModule(
        moduleSeed moduleSeed: ApplicationModuleSeed,
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
        -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        let marshrouteNavigationStack = moduleSeed.marshrouteNavigationStack
        
        let navigationController = marshrouteNavigationStack.routerControllersProvider.navigationController()
        
        let animatingTransitionsHandler = marshrouteNavigationStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let animatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let routerSeed = RouterSeed(
            moduleSeed: moduleSeed,
            transitionsHandlerBox: animatingTransitionsHandlerBox
        )
        
        let viewController = deriveViewController(
            routerSeed: routerSeed
        )
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            animatingTransitionsHandler: animatingTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: moduleSeed.transitionId
        )
        
        animatingTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return (navigationController, animatingTransitionsHandler)
    }
    
    func masterDetailModule(
        moduleSeed moduleSeed: ApplicationModuleSeed,
        @noescape deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController)
        -> (splitViewController: UISplitViewController, containingTransitionsHandler: ContainingTransitionsHandler)
    {
        let marshrouteNavigationStack = moduleSeed.marshrouteNavigationStack
        
        let masterNavigationController = marshrouteNavigationStack.routerControllersProvider.navigationController()
        let detailNavigationController = marshrouteNavigationStack.routerControllersProvider.navigationController()
        
        
        let masterAnimatingTransitionsHandler = marshrouteNavigationStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: masterNavigationController
        )
        
        let detailAnimatingTransitionsHandler = marshrouteNavigationStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: detailNavigationController
        )
        
        let masterAnimatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: masterAnimatingTransitionsHandler
        )
        
        let detailAnimatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: detailAnimatingTransitionsHandler
        )
        
        do { // master
            let masterDetailRouterSeed = MasterDetailRouterSeed(
                moduleSeed: moduleSeed,
                masterTransitionsHandlerBox: masterAnimatingTransitionsHandlerBox,
                detailTransitionsHandlerBox: detailAnimatingTransitionsHandlerBox
            )
            
            let masterViewController = deriveMasterViewController(
                routerSeed: masterDetailRouterSeed
            )
            
            let resetContext = ResettingTransitionContext(
                settingRootViewController: masterViewController,
                forNavigationController: masterNavigationController,
                animatingTransitionsHandler: masterAnimatingTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: moduleSeed.transitionId
            )
            
            masterAnimatingTransitionsHandler.resetWithTransition(
                context: resetContext
            )
        }
        
        do { // detail
            let detailRouterSeed = RouterSeed(
                moduleSeed: moduleSeed,
                transitionsHandlerBox: detailAnimatingTransitionsHandlerBox
            )
            
            let viewController = deriveDetailViewController(
                routerSeed: detailRouterSeed
            )
            
            let resetContext = ResettingTransitionContext(
                settingRootViewController: viewController,
                forNavigationController: detailNavigationController,
                animatingTransitionsHandler: detailAnimatingTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: moduleSeed.transitionId
            )
            
            detailAnimatingTransitionsHandler.resetWithTransition(
                context: resetContext
            )
        }
        
        let splitViewController = marshrouteNavigationStack.routerControllersProvider.splitViewController()
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let splitViewTransitionsHandler = marshrouteNavigationStack.transitionsHandlersProvider.splitViewTransitionsHandler(
            splitViewController: splitViewController
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterAnimatingTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailAnimatingTransitionsHandler
        
        return (splitViewController, splitViewTransitionsHandler)
    }
}
