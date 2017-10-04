import UIKit

public final class MarshrouteFacade {
    // MARK: - Private properties
    private let marshrouteStack: MarshrouteStack
    private let transitionId: TransitionId    
    
    // MARK: - Init
    public init(marshrouteSetupService: MarshrouteSetupService = MarshrouteSetupServiceImpl()) {
        marshrouteStack = marshrouteSetupService.marshrouteStack()
        transitionId = marshrouteStack.transitionIdGenerator.generateNewTransitionId()
    }
    
    // MARK: - Public
    public func navigationModule(
        _ navigationController: UINavigationController? = nil,
        withRootViewControllerDerivedFrom deriveViewController: (RouterSeed) -> (UIViewController))
        -> MarshrouteModule<UINavigationController>
    {
        let navigationController = navigationController
            ?? marshrouteStack.routerControllersProvider.navigationController()
        
        let navigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let routerSeed = makeRouterSeed(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
    
        let viewController = deriveViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            animatingTransitionsHandler: navigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: transitionId
        )
        
        navigationTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return MarshrouteModule<UINavigationController>(
            viewController: navigationController,
            routerSeed: routerSeed
        )
    }
    
    public func tabBarController(
        _ tabBarController: UITabBarController? = nil,
        tabControllerDeriviationFunctionType: [TabControllerDeriviationFunctionType])
        -> MarshrouteModule<UITabBarController>
    {
        let tabBarController = tabBarController ?? UITabBarController()
        
        let tabTransitionsHandler = marshrouteStack.transitionsHandlersProvider.tabBarTransitionsHandler(
            tabBarController: tabBarController
        )
        
        var animatingTransitionsHandlers = [Int: AnimatingTransitionsHandler]()
        var containingTransitionsHandlers = [Int: ContainingTransitionsHandler]()
        var tabControllers = [UIViewController]()
         
        for (tabIndex, deriviationFunctionType) in tabControllerDeriviationFunctionType.enumerated() {
            switch deriviationFunctionType {
            case .detailController(let detailControllerDeriviationFunctionType):
                let (viewController, animatingTransitionsHandler) = deriveDetailViewControllerFrom(
                    detailControllerDeriviationFunctionType: detailControllerDeriviationFunctionType
                )
                tabControllers.append(viewController)
                animatingTransitionsHandlers[tabIndex] = animatingTransitionsHandler
                
            case .masterDetailViewController(let masterDetailViewControllerDeriviationFuctionType):
                let (viewController, containingTransitionsHandler) = deriveMasterDetailViewControllerFrom(
                    masterDetailViewControllerDeriviationFuctionType: masterDetailViewControllerDeriviationFuctionType
                )
                tabControllers.append(viewController)
                containingTransitionsHandlers[tabIndex] = containingTransitionsHandler
            }
        }
        
        tabTransitionsHandler.animatingTransitionsHandlers = animatingTransitionsHandlers
        tabTransitionsHandler.containingTransitionsHandlers = containingTransitionsHandlers
        
        let routerSeed = makeRouterSeed(
            containingTransitionsHandler: tabTransitionsHandler
        )
        
        return MarshrouteModule<UITabBarController>(
            viewController: tabBarController,
            routerSeed: routerSeed
        )
    }
    
    // MARK: - Detail helpers
    private func makeRouterSeed(
        animatingTransitionsHandler: AnimatingTransitionsHandler)
        -> RouterSeed
    {
        return makeRouterSeed(
            transitionsHandlerBox: .init(animatingTransitionsHandler: animatingTransitionsHandler)
        )
    }
    
    private func makeRouterSeed(
        containingTransitionsHandler: ContainingTransitionsHandler)
        -> RouterSeed
    {
        return makeRouterSeed(
            transitionsHandlerBox: .init(containingTransitionsHandler: containingTransitionsHandler)
        )
    }
    
    private func makeRouterSeed(
        transitionsHandlerBox: TransitionsHandlerBox)
        -> RouterSeed
    {
        return RouterSeed(
            transitionsHandlerBox: transitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: marshrouteStack.transitionsHandlersProvider,
            transitionIdGenerator: marshrouteStack.transitionIdGenerator,
            controllersProvider: marshrouteStack.routerControllersProvider
        )
    }
    
    private func deriveDetailViewControllerFrom(
        detailControllerDeriviationFunctionType: DetailViewControllerDeriviationFunctionType)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        switch detailControllerDeriviationFunctionType {
        case .controller(let deriveDetailViewController):
            return deriveDetailViewControllerFrom(
                deriveDetailViewController: deriveDetailViewController
            )
            
        case .controllerInNavigationController(let deriveDetailViewController):
            return deriveDetailViewControllerInNavigationControllerFrom(
                deriveDetailViewController: deriveDetailViewController
            )
        }
    }
    
    private func deriveDetailViewControllerFrom(
        deriveDetailViewController: DeriveDetailViewController)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        let animatingTransitionsHandler = marshrouteStack.transitionsHandlersProvider.animatingTransitionsHandler()
        
        let routerSeed = makeRouterSeed(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let viewController = deriveDetailViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            registeringViewController: viewController,
            animatingTransitionsHandler: animatingTransitionsHandler,
            transitionId: transitionId
        )
        
        animatingTransitionsHandler.resetWithTransition(context: resetContext)
        
        return (viewController, animatingTransitionsHandler)
    }
    
    private func deriveDetailViewControllerInNavigationControllerFrom(
        deriveDetailViewController: DeriveDetailViewController)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        let navigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        let navigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let routerSeed = makeRouterSeed(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
        let viewController = deriveDetailViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            animatingTransitionsHandler: navigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: transitionId
        )
        
        navigationTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return (viewController, navigationTransitionsHandler)
    }
    
    // MARK: - MasterDetail helpers
    private func makeMasterDetailRouterSeed(
        masterTransitionsHandlerBox: TransitionsHandlerBox,
        detailTransitionsHandlerBox: TransitionsHandlerBox)
        -> MasterDetailRouterSeed
    {
        return MasterDetailRouterSeed(
            masterTransitionsHandlerBox: masterTransitionsHandlerBox,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox,
            transitionId: transitionId,
            presentingTransitionsHandler: nil,
            transitionsHandlersProvider: marshrouteStack.transitionsHandlersProvider,
            transitionIdGenerator: marshrouteStack.transitionIdGenerator,
            controllersProvider: marshrouteStack.routerControllersProvider
        )
    }
    
    private func deriveMasterViewControllerFrom(
        detailTransitionsHandlerBox: TransitionsHandlerBox,
        masterControllerDeriviationFunctionType: MasterViewControllerDeriviationFunctionType)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        switch masterControllerDeriviationFunctionType {
        case .controller(let deriveMasterViewController):
            return deriveMasterViewControllerFrom(
                detailTransitionsHandlerBox: detailTransitionsHandlerBox,
                deriveMasterViewController: deriveMasterViewController
            )
            
        case .controllerInNavigationController(let deriveMasterViewController):
            return deriveMasterViewControllerInNavigationControllerFrom(
                detailTransitionsHandlerBox: detailTransitionsHandlerBox,
                deriveMasterViewController: deriveMasterViewController
            )
        }
    }
    
    private func deriveMasterViewControllerFrom(
        detailTransitionsHandlerBox: TransitionsHandlerBox,
        deriveMasterViewController: DeriveMasterViewController)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        let animatingTransitionsHandler = marshrouteStack.transitionsHandlersProvider.animatingTransitionsHandler()
        
        let routerSeed = makeMasterDetailRouterSeed(
            masterTransitionsHandlerBox: .init(animatingTransitionsHandler: animatingTransitionsHandler),
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
        
        let viewController = deriveMasterViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            registeringViewController: viewController,
            animatingTransitionsHandler: animatingTransitionsHandler,
            transitionId: transitionId
        )
        
        animatingTransitionsHandler.resetWithTransition(context: resetContext)
        
        return (viewController, animatingTransitionsHandler)
    }
    
    private func deriveMasterViewControllerInNavigationControllerFrom(
        detailTransitionsHandlerBox: TransitionsHandlerBox,
        deriveMasterViewController: DeriveMasterViewController)
        -> (UIViewController, AnimatingTransitionsHandler)
    {
        let navigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        let navigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let routerSeed = makeMasterDetailRouterSeed(
            masterTransitionsHandlerBox: .init(animatingTransitionsHandler: navigationTransitionsHandler),
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
        
        let viewController = deriveMasterViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            animatingTransitionsHandler: navigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: transitionId
        )
        
        navigationTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return (viewController, navigationTransitionsHandler)
    }
    
    private func deriveMasterDetailViewControllerFrom(
        masterDetailViewControllerDeriviationFuctionType: MasterDetailViewControllerDeriviationFuctionType)
        -> (UIViewController, SplitViewTransitionsHandlerImpl)
    {
        let (detailController, detaillTransitionHandler) = deriveDetailViewControllerFrom(
            detailControllerDeriviationFunctionType: masterDetailViewControllerDeriviationFuctionType.detailFunctionType
        )
        
        let (masterController, masterTransitionsHandler) = deriveMasterViewControllerFrom(
            detailTransitionsHandlerBox: .init(animatingTransitionsHandler: detaillTransitionHandler),
            masterControllerDeriviationFunctionType: masterDetailViewControllerDeriviationFuctionType.masterFunctionType
        )
        
        let splitViewController = marshrouteStack.routerControllersProvider.splitViewController()
        
        splitViewController.viewControllers = [masterController, detailController]
        
        let splitTransitionsHandler = marshrouteStack.transitionsHandlersProvider.splitViewTransitionsHandler(
            splitViewController: splitViewController
        )
        
        splitTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitTransitionsHandler.detailTransitionsHandler = detaillTransitionHandler
        
        return (splitViewController, splitTransitionsHandler)
    }
}
