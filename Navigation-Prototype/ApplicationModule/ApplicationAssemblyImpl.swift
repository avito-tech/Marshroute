import UIKit

// MARK: - ApplicationAssemblyImpl
final class ApplicationAssemblyImpl: ApplicationAssembly {
    var sharedTransitionIdGenerator: TransitionIdGenerator {
        return TransitionIdGeneratorImpl.instance
    }
    
    func module() -> (viewController: UIViewController, moduleInput: ApplicationModuleInput) {
        let applicationModuleHolder = ApplicationModuleHolder.instance
        
        if let applicationModule = applicationModuleHolder.applicationModule {
            return applicationModule
        }
        
        let navigationRootsHolder = NavigationRootsHolder.instance
        
        let applicationModule = module(navigationRootsHolder: navigationRootsHolder)
        
        applicationModuleHolder.applicationModule = applicationModule
        
        return applicationModule
    }
    
    func sharedModuleInput() -> ApplicationModuleInput {
        return module().moduleInput
    }
}

// MARK: - helpers
private extension ApplicationAssemblyImpl {
    func module(navigationRootsHolder navigationRootsHolder: NavigationRootsHolder) -> (viewController: UIViewController, moduleInput: ApplicationModuleInput) {
        let interactor = ApplicationInteractorImpl()
        
        let presenter = ApplicationPresenter(
            interactor: interactor
        )
        
        let tabBarController = ApplicationViewController(
            viewOutput: presenter
        )
        
        presenter.viewInput = tabBarController
        
        let sharedTransitionId = sharedTransitionIdGenerator.generateNewTransitionId()
        let sharedTransitionsCoordinator = navigationRootsHolder.transitionsCoordinator
        
        let (viewControllers, animatingTransitionsHandlers, containingTransitinsHandlers) = createTabControllers(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator)

        tabBarController.viewControllers = viewControllers
        
        let tabBarTransitionsHandler = TabBarTransitionsHandlerImpl(
            tabBarController: tabBarController,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        tabBarTransitionsHandler.animatingTransitionsHandlers = animatingTransitionsHandlers
        tabBarTransitionsHandler.containingTransitionsHandlers = containingTransitinsHandlers
        
        let tabBarTransitionsHandlerBox = RouterTransitionsHandlerBox(containingTransitionsHandler: tabBarTransitionsHandler)
        
        let routerSeed = BaseRouterSeed(transitionsHandlerBox: tabBarTransitionsHandlerBox,
            transitionId: sharedTransitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: sharedTransitionsCoordinator,
            transitionIdGenerator: sharedTransitionIdGenerator)
        
        let router = ApplicationRouterImpl(routerSeed: routerSeed)
        
        presenter.router = router
        
        navigationRootsHolder.rootTransitionsHandler = tabBarTransitionsHandler
        
        return (tabBarController, presenter)
    }

    func createTabControllers(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  ([UIViewController], [Int: AnimatingTransitionsHandler], [Int: ContainingTransitionsHandler])
    {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            ? createTabControllersIpad(
                sharedTransitionId: sharedTransitionId,
                sharedTransitionsCoordinator: sharedTransitionsCoordinator)
                
            : createTabControllersIphone(
                sharedTransitionId: sharedTransitionId,
                sharedTransitionsCoordinator: sharedTransitionsCoordinator)
    }
}

// MARK: - iPhone
private extension ApplicationAssemblyImpl {
    private func createTabControllersIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  ([UIViewController], [Int: AnimatingTransitionsHandler], [Int: ContainingTransitionsHandler])
    {
        let (firstViewController, firstTransitionsHandler) = createFirstTabControllerIphone(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let (secondViewController , secondTransitionsHandler) = createSecondTabControllerIphone(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let (thirdViewController, thirdTransitionsHandler) = createThirdTabControllerIphone(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let controllers = [firstViewController, secondViewController, thirdViewController]
        
        let result = (
            controllers,
            [0 : firstTransitionsHandler, 1 : secondTransitionsHandler, 2 : thirdTransitionsHandler],
            [Int: ContainingTransitionsHandler]()
        )
        return result
    }

    func createFirstTabControllerIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  (UIViewController, AnimatingTransitionsHandler)
    {
        let firstNavigation = UINavigationController()
        let firstTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: firstNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        let firstTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: firstTransitionsHandler)
        
        do {
            let firstRouterSeed = BaseRouterSeed(transitionsHandlerBox: firstTransitionsHandlerBox,
                transitionId: sharedTransitionId,
                presentingTransitionsHandler: nil,
                transitionsCoordinator: sharedTransitionsCoordinator,
                transitionIdGenerator: sharedTransitionIdGenerator)
            
            let firstViewController = AssemblyFactory.firstModuleAssembly().iphoneModule(
                title: "1",
                canShowFirstModule: true,
                canShowSecondModule: false,
                dismissable: false,
                withTimer: true,
                routerSeed: firstRouterSeed)
            
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: firstViewController,
                animatingTransitionsHandler: firstTransitionsHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            firstTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        firstNavigation.tabBarItem.title = "1"
        
        return (firstNavigation, firstTransitionsHandler)
    }
    
    func createSecondTabControllerIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  (UIViewController, AnimatingTransitionsHandler)
    {
        let secondNavigation = UINavigationController()
        let secondTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: secondNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        let secondTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: secondTransitionsHandler)
        
        do {
            let secondRouterSeed = BaseRouterSeed(transitionsHandlerBox: secondTransitionsHandlerBox,
                transitionId: sharedTransitionId,
                presentingTransitionsHandler: nil,
                transitionsCoordinator: sharedTransitionsCoordinator,
                transitionIdGenerator: sharedTransitionIdGenerator)
            
            let secondViewController = AssemblyFactory.secondModuleAssembly().iphoneModule(
                title: "1",
                withTimer: true,
                canShowModule1: true,
                routerSeed: secondRouterSeed)
            
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: secondViewController,
                animatingTransitionsHandler: secondTransitionsHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            secondTransitionsHandler.resetWithTransition(context: resetContext)
        }

        secondNavigation.tabBarItem.title = "2"
        
        return (secondNavigation, secondTransitionsHandler)
    }
    
    func createThirdTabControllerIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  (UIViewController, AnimatingTransitionsHandler)
    {
        let thirdNavigation = UINavigationController()
        let thirdTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: thirdNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        do {
            let viewController = UIViewController()
            
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: thirdTransitionsHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            thirdTransitionsHandler.resetWithTransition(context: resetContext)
        }

        thirdNavigation.tabBarItem.title = "3"
        
        return (thirdNavigation, thirdTransitionsHandler)
    }
}

// MARK: - iPad
private extension ApplicationAssemblyImpl {
    func createTabControllersIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  ([UIViewController], [Int: AnimatingTransitionsHandler], [Int: ContainingTransitionsHandler])
    {
        let (firstViewController, firstTransitionsHandler) = createFirstTabControllerIpad(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let (secondViewController, secondTransitionsHandler) = createSecondTabControllerIpad(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let (thirdViewController, thirdTransitionsHandler)  = createThirdTabControllerIpad(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let controllers = [firstViewController, secondViewController, thirdViewController]
        
        let result = (
            controllers,
            [1 : secondTransitionsHandler, 2 : thirdTransitionsHandler],
            [0 : firstTransitionsHandler]
        )
        
        return result
    }
    
    func createFirstTabControllerIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (UIViewController, ContainingTransitionsHandler)
    {
        let firstSplit = UISplitViewController()
        let firstSplitTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: firstSplit,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let masterNavigation = UINavigationController()
            let detailNavigation = UINavigationController()
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            
            let masterTransitionsHandler = NavigationTransitionsHandlerImpl(
                navigationController: masterNavigation,
                transitionsCoordinator: sharedTransitionsCoordinator)
            
            let detailTransitionsHandler = NavigationTransitionsHandlerImpl(
                navigationController: detailNavigation,
                transitionsCoordinator: sharedTransitionsCoordinator)
            
            
            firstSplitTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
            firstSplitTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
            
            let masterTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: masterTransitionsHandler)
            let detailTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: detailTransitionsHandler)
            
            do {
                let masterRouterSeed = BaseRouterSeed(transitionsHandlerBox: masterTransitionsHandlerBox,
                    transitionId: sharedTransitionId,
                    presentingTransitionsHandler: nil,
                    transitionsCoordinator: sharedTransitionsCoordinator,
                    transitionIdGenerator: sharedTransitionIdGenerator)
                
                let masterViewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule(
                    title: "1",
                    canShowFirstModule: true,
                    canShowSecondModule: false,
                    dismissable: false,
                    withTimer: true,
                    routerSeed: masterRouterSeed,
                    detailTransitionsHandlerBox: detailTransitionsHandlerBox)
                
                let resetMasterContext = ForwardTransitionContext(
                    resettingWithViewController: masterViewController,
                    animatingTransitionsHandler: masterTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: sharedTransitionId)
                
                masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
            }
            
            do {
                let detailViewController = UIViewController()
                
                let resetDetailContext = ForwardTransitionContext(
                    resettingWithViewController: detailViewController,
                    animatingTransitionsHandler: detailTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: sharedTransitionId)
                
                detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
            }

        }
        
        firstSplit.tabBarItem.title = "1"
        
        return (firstSplit, firstSplitTransitionsHandler)
    }
    
    func createSecondTabControllerIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        let secondNavigation = UINavigationController()
        let secondTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: secondNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        let secondTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: secondTransitionsHandler)
        
        do {
            let secondRouterSeed = BaseRouterSeed(transitionsHandlerBox: secondTransitionsHandlerBox,
                transitionId: sharedTransitionId,
                presentingTransitionsHandler: nil,
                transitionsCoordinator: sharedTransitionsCoordinator,
                transitionIdGenerator: sharedTransitionIdGenerator)
            
            let second = AssemblyFactory.secondModuleAssembly().ipadModule(
                title: "1",
                withTimer: true,
                canShowModule1: true,
                routerSeed: secondRouterSeed)
            
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: second,
                animatingTransitionsHandler: secondTransitionsHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            secondTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        secondNavigation.tabBarItem.title = "2"

        return (secondNavigation, secondTransitionsHandler)
    }

    func createThirdTabControllerIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        let thirdNavigation = UINavigationController()
        let thirdTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: thirdNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let viewController = UIViewController()
            
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: thirdTransitionsHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            thirdTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        thirdNavigation.tabBarItem.title = "3"
        
        return (thirdNavigation, thirdTransitionsHandler)
    }
}