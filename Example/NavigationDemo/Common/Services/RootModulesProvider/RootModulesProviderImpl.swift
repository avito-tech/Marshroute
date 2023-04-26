import Marshroute

final class RootModulesProviderImpl: RootModulesProvider {
    func detailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> NavigationModule
    {
        let marshrouteStack = moduleSeed.marshrouteStack
        
        let navigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        let navigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let animatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
        let routerSeed = RouterSeed(
            moduleSeed: moduleSeed,
            transitionsHandlerBox: animatingTransitionsHandlerBox
        )
        
        let viewController = deriveViewController(
            routerSeed
        )
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            navigationTransitionsHandler: navigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: moduleSeed.transitionId
        )
        
        navigationTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return NavigationModule(
            navigationController: navigationController,
            navigationTransitionsHandler: navigationTransitionsHandler
        )
    }
    
    func masterDetailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> SplitViewModule
    {
        let marshrouteStack = moduleSeed.marshrouteStack
        
        let masterNavigationController = marshrouteStack.routerControllersProvider.navigationController()
        let detailNavigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        let masterNavigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: masterNavigationController
        )
        
        let detailNavigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: detailNavigationController
        )
        
        let masterAnimatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: masterNavigationTransitionsHandler
        )
        
        let detailAnimatingTransitionsHandlerBox = RouterTransitionsHandlerBox(
            animatingTransitionsHandler: detailNavigationTransitionsHandler
        )
        
        do { // master
            let masterDetailRouterSeed = MasterDetailRouterSeed(
                moduleSeed: moduleSeed,
                masterTransitionsHandlerBox: masterAnimatingTransitionsHandlerBox,
                detailTransitionsHandlerBox: detailAnimatingTransitionsHandlerBox
            )
            
            let masterViewController = deriveMasterViewController(
                masterDetailRouterSeed
            )
            
            let resetContext = ResettingTransitionContext(
                settingRootViewController: masterViewController,
                forNavigationController: masterNavigationController,
                navigationTransitionsHandler: masterNavigationTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: moduleSeed.transitionId
            )
            
            masterNavigationTransitionsHandler.resetWithTransition(
                context: resetContext
            )
        }
        
        do { // detail
            let detailRouterSeed = RouterSeed(
                moduleSeed: moduleSeed,
                transitionsHandlerBox: detailAnimatingTransitionsHandlerBox
            )
            
            let viewController = deriveDetailViewController(
                detailRouterSeed
            )
            
            let resetContext = ResettingTransitionContext(
                settingRootViewController: viewController,
                forNavigationController: detailNavigationController,
                navigationTransitionsHandler: detailNavigationTransitionsHandler,
                animator: SetNavigationTransitionsAnimator(),
                transitionId: moduleSeed.transitionId
            )
            
            detailNavigationTransitionsHandler.resetWithTransition(
                context: resetContext
            )
        }
        
        let splitViewController = marshrouteStack.routerControllersProvider.splitViewController()
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let splitViewTransitionsHandler = marshrouteStack.transitionsHandlersProvider.splitViewTransitionsHandler(
            splitViewController: splitViewController
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterNavigationTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailNavigationTransitionsHandler
        
        return SplitViewModule(
            splitViewController: splitViewController,
            splitViewTransitionsHandler: splitViewTransitionsHandler
        )
    }
}
