import Marshroute

final class RootModulesProviderImpl: RootModulesProvider {
    func detailModule(
        moduleSeed: ApplicationModuleSeed,
        deriveViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> (navigationController: UINavigationController, animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        let marshrouteStack = moduleSeed.marshrouteStack
        
        let navigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        let animatingTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
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
            routerSeed
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
        moduleSeed: ApplicationModuleSeed,
        deriveMasterViewController: (_ routerSeed: MasterDetailRouterSeed) -> UIViewController,
        deriveDetailViewController: (_ routerSeed: RouterSeed) -> UIViewController)
        -> (splitViewController: UISplitViewController, containingTransitionsHandler: ContainingTransitionsHandler)
    {
        let marshrouteStack = moduleSeed.marshrouteStack
        
        let masterNavigationController = marshrouteStack.routerControllersProvider.navigationController()
        let detailNavigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        
        let masterAnimatingTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: masterNavigationController
        )
        
        let detailAnimatingTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
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
                masterDetailRouterSeed
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
                detailRouterSeed
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
        
        let splitViewController = marshrouteStack.routerControllersProvider.splitViewController()
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let splitViewTransitionsHandler = marshrouteStack.transitionsHandlersProvider.splitViewTransitionsHandler(
            splitViewController: splitViewController
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterAnimatingTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailAnimatingTransitionsHandler
        
        return (splitViewController, splitViewTransitionsHandler)
    }
}
