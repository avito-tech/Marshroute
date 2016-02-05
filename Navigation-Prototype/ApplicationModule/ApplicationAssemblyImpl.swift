import UIKit

// MARK: - NavigationRootsHolder, NavigationRootsHolderimpl
private protocol NavigationRootsHolder: class {
    var rootTransitionsHandler: TransitionsHandler? { get set }
    var transitionsCoordinator: TransitionsCoordinator { get }
}

private class NavigationRootsHolderImpl: NavigationRootsHolder {
    static let instance = NavigationRootsHolderImpl()
    
    private var rootTransitionsHandler: TransitionsHandler?

    private let transitionsCoordinator: TransitionsCoordinator = TransitionsCoordinatorImpl(
        stackClientProvider: TransitionContextsStackClientProviderImpl()
    )
}

// MARK: - ApplicationModuleHolder, ApplicationModuleHolderImpl
private protocol ApplicationModuleHolder {
    var applicationModule: (UIViewController, ApplicationModuleInput)? { get set }
}

private class ApplicationModuleHolderImpl: ApplicationModuleHolder {
    static let instance = ApplicationModuleHolderImpl()
    
    private var applicationModule: (UIViewController, ApplicationModuleInput)?
}

// MARK: - ApplicationAssemblyImpl
final class ApplicationAssemblyImpl: ApplicationAssembly  {
    
    func module() -> (viewController: UIViewController, moduleInput: ApplicationModuleInput) {
        let applicationModuleHolder = ApplicationModuleHolderImpl.instance
        
        if let applicationModule = applicationModuleHolder.applicationModule {
            return applicationModule
        }
        
        let navigationRootsHolder = NavigationRootsHolderImpl.instance
        
        let applicationModule = module(navigationRootsHolder: navigationRootsHolder)
        
        applicationModuleHolder.applicationModule = applicationModule
        
        return applicationModule
    }
}

// MARK: - helpers
private extension ApplicationAssemblyImpl {
    func module(navigationRootsHolder navigationRootsHolder: NavigationRootsHolder) -> (UIViewController, ApplicationModuleInput) {
        let interactor = ApplicationInteractorImpl()
        
        let presenter = ApplicationPresenter(
            interactor: interactor
        )
        
        let tabBarController = ApplicationViewController(
            output: presenter
        )
        
        presenter.viewInput = tabBarController
        interactor.output = presenter
        
        let sharedTransitionId = transitionIdGenerator.generateNewTransitionId()
        let sharedTransitionsCoordinator = navigationRootsHolder.transitionsCoordinator
        
        let controllersAndHandlers = createTabControllers(
            sharedTransitionId: sharedTransitionId,
            sharedTransitionsCoordinator: sharedTransitionsCoordinator)

        tabBarController.viewControllers = controllersAndHandlers.0
        
        let tabTransitionsHandler = TabBarTransitionsHandlerImpl(
            tabBarController: tabBarController,
            transitionsCoordinator: sharedTransitionsCoordinator)
        
        tabTransitionsHandler.tabTransitionsHandlers = controllersAndHandlers.1
        
        let router = ApplicationRouterImpl(
            transitionsHandler: tabTransitionsHandler,
            transitionId: sharedTransitionId,
            presentingTransitionsHandler: nil,
            transitionsCoordinator: sharedTransitionsCoordinator
        )
        
        presenter.router = router
        
        navigationRootsHolder.rootTransitionsHandler = tabTransitionsHandler
        
        return (tabBarController, presenter)
    }

    private func createTabControllers(
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
    
    private func createTabControllersIphone(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> ([UIViewController], [TransitionsHandler])
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
        
        
        firstNavigation.tabBarItem.title = "1"
        secondNavigation.tabBarItem.title = "2"
        thirdNavigation.tabBarItem.title = "3"
        
        let controllers = [firstNavigation, secondNavigation, thirdNavigation]
        return (controllers, [firstTransitionsHandler, secondTransitionsHandler, thirdTransitionsHandler])
    }
    
    private func createTabControllersIpad(
        sharedTransitionId sharedTransitionId: TransitionId,
        sharedTransitionsCoordinator: TransitionsCoordinator)
        -> ([UIViewController], [TransitionsHandler])
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
        
        firstSplit.tabBarItem.title = "1"
        secondNavigation.tabBarItem.title = "2"
        thirdNavigation.tabBarItem.title = "3"

        let controllers = [firstSplit, secondNavigation, thirdNavigation]
        return (controllers, [firstSplitTransitionsHandler, secondTransitionsHandler, thirdTransitionsHandler])
    }
}

// MARK: - TransitionsGeneratorStorer
extension ApplicationAssemblyImpl: TransitionsGeneratorStorer {}