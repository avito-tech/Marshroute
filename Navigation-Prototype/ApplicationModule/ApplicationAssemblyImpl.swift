import UIKit

/// NavigationRootsHolder
private class NavigationRootsHolder {
    static let instance = NavigationRootsHolder()
    
    private var rootTransitionsHandler: TransitionsHandler?

    private let transitionsCoordinator: TransitionsCoordinator = TransitionsCoordinatorImpl(
        stackClientProvider: TransitionContextsStackClientProviderImpl()
    )
}

/// ApplicationModuleHolder
private class ApplicationModuleHolder {
    static let instance = ApplicationModuleHolder()
    
    private var applicationModule: (UIViewController, ApplicationModuleInput)?
}

// MARK: - ApplicationAssemblyImpl
final class ApplicationAssemblyImpl: ApplicationAssembly {
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
        
        let sharedTransitionId = transitionIdGenerator.generateNewTransitionId()
        let sharedTransitionsCoordinator = navigationRootsHolder.transitionsCoordinator
        
        let (viewControllers, tabBarTransitionsHandlers) = createTabControllers(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator)

        tabBarController.viewControllers = viewControllers
        
        let tabBarTransitionsHandler = TabBarTransitionsHandlerImpl(
            tabBarController: tabBarController,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        tabBarTransitionsHandler.tabTransitionsHandlers = tabBarTransitionsHandlers
        
        let router = ApplicationRouterImpl(
            transitionsHandler: tabBarTransitionsHandler,
            transitionId: sharedTransitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: sharedTransitionsCoordinator
        )
        
        presenter.router = router
        
        navigationRootsHolder.rootTransitionsHandler = tabBarTransitionsHandler
        
        return (tabBarController, presenter)
    }

    func createTabControllers(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        ->  ([UIViewController], [TransitionsHandler])
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
private extension ApplicationAssembly {
    private func createTabControllersIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (viewControllers: [UIViewController], transitionsHandlers: [TransitionsHandler])
    {
        let firstTab = createFirstTabControllerIphone(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let secondTab = createSecondTabControllerIphone(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let thirdTab = createThirdTabControllerIphone(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let controllers = [firstTab.viewController, secondTab.viewController, thirdTab.viewController]
        
        let result = (
            controllers,
            [firstTab.transitionsHandler, secondTab.transitionsHandler, thirdTab.transitionsHandler]
        )
        return result
    }

    func createFirstTabControllerIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (viewController: UIViewController, transitionsHandler: TransitionsHandler)
    {
        let firstNavigation = UINavigationController()
        let firstTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: firstNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let firstViewController = AssemblyFactory.firstModuleAssembly().iphoneModule("1", presentingTransitionsHandler: nil, transitionId: sharedTransitionId, transitionsHandler: firstTransitionsHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true, transitionsCoordinator: sharedTransitionsCoordinator).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: firstViewController,
                transitionsHandler: firstTransitionsHandler,
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
        -> (viewController: UIViewController, transitionsHandler: TransitionsHandler)
    {
        let secondNavigation = UINavigationController()
        let secondTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: secondNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let secondViewController = AssemblyFactory.secondModuleAssembly().iphoneModule(secondTransitionsHandler, title: "1", withTimer: true, canShowModule1: true, transitionId: sharedTransitionId, presentingTransitionsHandler: nil, transitionsCoordinator: sharedTransitionsCoordinator).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: secondViewController,
                transitionsHandler: secondTransitionsHandler,
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
        -> (viewController: UIViewController, transitionsHandler: TransitionsHandler)
    {
        let thirdNavigation = UINavigationController()
        let thirdTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: thirdNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        do {
            let viewController = UIViewController()
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: thirdTransitionsHandler,
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
        -> (viewControllers: [UIViewController], transitionsHandlers: [TransitionsHandler])
    {
        let firstTab = createFirstTabControllerIpad(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let secondTab = createSecondTabControllerIpad(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let thirdTab = createThirdTabControllerIpad(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator
        )
        
        let controllers = [firstTab.viewController, secondTab.viewController, thirdTab.viewController]
        
        let result = (
            controllers,
            [firstTab.transitionsHandler, secondTab.transitionsHandler, thirdTab.transitionsHandler]
        )
        
        return result
    }
    
    func createFirstTabControllerIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (viewController: UIViewController, transitionsHandler: TransitionsHandler)
    {
        let firstSplit = UISplitViewController()
        let firstSplitTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: firstSplit,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let sharedFirstTransitionId = transitionIdGenerator.generateNewTransitionId()
            
            let masterNavigation = UINavigationController()
            let detailNavigation = UINavigationController()
            
            firstSplit.viewControllers = [masterNavigation, detailNavigation]
            
            let masterTransitionsHandler = NavigationTransitionsHandlerImpl(
                navigationController: masterNavigation,
                transitionsCoordinator: sharedTransitionsCoordinator)
            
            let detailTransitionsHandler = NavigationTransitionsHandlerImpl(
                navigationController: detailNavigation,
                transitionsCoordinator: sharedTransitionsCoordinator)
            
            do {
                let masterViewController = AssemblyFactory.firstModuleAssembly().ipadMasterModule("1", presentingTransitionsHandler: nil, transitionId: sharedFirstTransitionId, transitionsHandler: masterTransitionsHandler, detailTransitionsHandler: detailTransitionsHandler, canShowFirstModule: true, canShowSecondModule: false, dismissable: false, withTimer: true, transitionsCoordinator: sharedTransitionsCoordinator).0
                
                let resetMasterContext = ForwardTransitionContext(
                    resetingWithViewController: masterViewController,
                    transitionsHandler: masterTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: sharedFirstTransitionId)
                
                masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
            }
            
            do {
                let detailViewController = UIViewController()
                
                let resetDetailContext = ForwardTransitionContext(
                    resetingWithViewController: detailViewController,
                    transitionsHandler: detailTransitionsHandler,
                    animator: NavigationTransitionsAnimator(),
                    transitionId: sharedFirstTransitionId)
                
                detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
            }
            
            firstSplitTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
            firstSplitTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        }
        
        firstSplit.tabBarItem.title = "1"
        
        return (firstSplit, firstSplitTransitionsHandler)
    }
    
    func createSecondTabControllerIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> (viewController: UIViewController, transitionsHandler: TransitionsHandler)
    {
        let secondNavigation = UINavigationController()
        let secondTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: secondNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let second = AssemblyFactory.secondModuleAssembly().ipadModule(secondTransitionsHandler, title: "1", withTimer: true, canShowModule1: true, transitionId: sharedTransitionId, presentingTransitionsHandler: nil, transitionsCoordinator: sharedTransitionsCoordinator).0
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: second,
                transitionsHandler: secondTransitionsHandler,
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
        -> (viewController: UIViewController, transitionsHandler: TransitionsHandler)
    {
        let thirdNavigation = UINavigationController()
        let thirdTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: thirdNavigation,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        do {
            let viewController = UIViewController()
            
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: thirdTransitionsHandler,
                animator: NavigationTransitionsAnimator(),
                transitionId: sharedTransitionId)
            
            thirdTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        thirdNavigation.tabBarItem.title = "3"
        
        return (thirdNavigation, thirdTransitionsHandler)
    }
}


// MARK: - TransitionsGeneratorStorer
extension ApplicationAssemblyImpl: TransitionsGeneratorStorer {}