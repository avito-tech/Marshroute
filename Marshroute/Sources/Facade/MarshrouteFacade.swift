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
        let (_, navigationController, routerSeed) = deriveDetailViewControllerInNavigationControllerFrom(
            deriveDetailViewController: deriveViewController,
            navigationController: navigationController
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
         
        func appendTransitionHandlersFrom(
            routerSeed: RouterSeed,
            forTabIndex tabIndex: Int)
        {
            switch routerSeed.transitionsHandlerBox {
            case .animating(strongBox: let animatingTransitionsHandlerBox):
                animatingTransitionsHandlers[tabIndex] = animatingTransitionsHandlerBox.unbox()
            case .containing(strongBox: let containingTransitionsHandlerBox):
                containingTransitionsHandlers[tabIndex] = containingTransitionsHandlerBox.unbox()
            }
        }
        
        for (tabIndex, deriviationFunctionType) in tabControllerDeriviationFunctionType.enumerated() {
            switch deriviationFunctionType {
            case .detailController(let detailControllerDeriviationFunctionType):
                let (viewController, routerSeed) = deriveDetailViewControllerFrom(
                    detailControllerDeriviationFunctionType: detailControllerDeriviationFunctionType
                )
                tabControllers.append(viewController)
                appendTransitionHandlersFrom(routerSeed: routerSeed, forTabIndex: tabIndex)
                
            case .masterDetailViewController(let masterDetailViewControllerDeriviationFuctionType):
                let (viewController, routerSeed) = deriveMasterDetailViewControllerFrom(
                    masterDetailViewControllerDeriviationFuctionType: masterDetailViewControllerDeriviationFuctionType
                )
                tabControllers.append(viewController)
                appendTransitionHandlersFrom(routerSeed: routerSeed, forTabIndex: tabIndex)
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
        -> (UIViewController, RouterSeed)
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
        -> (UIViewController, RouterSeed)
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
        
        return (viewController, routerSeed)
    }
    
    private func deriveDetailViewControllerInNavigationControllerFrom(
        deriveDetailViewController: DeriveDetailViewController)
        -> (UIViewController, RouterSeed)
    {
        let (viewController, _, routerSeed) =  deriveDetailViewControllerInNavigationControllerFrom(
            deriveDetailViewController: deriveDetailViewController,
            navigationController: nil
        )
        
        return (viewController, routerSeed)
    }
    
    private func deriveDetailViewControllerInNavigationControllerFrom(
        deriveDetailViewController: DeriveDetailViewController,
        navigationController: UINavigationController?)
        -> (UIViewController, UINavigationController, RouterSeed)
    {
        let navigationController = navigationController
            ?? marshrouteStack.routerControllersProvider.navigationController()
        
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
        
        return (viewController, navigationController, routerSeed)
    }
    
    // MARK: - MasterDetail helpers
    private func makeMasterDetailRouterSeed(
        masterAnimaingTransitionsHandler: AnimatingTransitionsHandler,
        detailTransitionsHandlerBox: TransitionsHandlerBox)
        -> MasterDetailRouterSeed
    {
        return makeMasterDetailRouterSeed(
            masterTransitionsHandlerBox: .init(animatingTransitionsHandler: masterAnimaingTransitionsHandler),
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
    }
    
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
        -> (UIViewController, MasterDetailRouterSeed)
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
        -> (UIViewController, MasterDetailRouterSeed)
    {
        let animatingMasterTransitionsHandler = marshrouteStack.transitionsHandlersProvider.animatingTransitionsHandler()
        
        let routerSeed = makeMasterDetailRouterSeed(
            masterAnimaingTransitionsHandler: animatingMasterTransitionsHandler,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
        
        let viewController = deriveMasterViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            registeringViewController: viewController,
            animatingTransitionsHandler: animatingMasterTransitionsHandler,
            transitionId: transitionId
        )
        
        animatingMasterTransitionsHandler.resetWithTransition(context: resetContext)
        
        return (viewController, routerSeed)
    }
    
    private func deriveMasterViewControllerInNavigationControllerFrom(
        detailTransitionsHandlerBox: TransitionsHandlerBox,
        deriveMasterViewController: DeriveMasterViewController)
        -> (UIViewController, MasterDetailRouterSeed)
    {
        let navigationController = marshrouteStack.routerControllersProvider.navigationController()
        
        let navigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let routerSeed = makeMasterDetailRouterSeed(
            masterAnimaingTransitionsHandler: navigationTransitionsHandler,
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
        
        return (viewController, routerSeed)
    }
    
    private func deriveMasterDetailViewControllerFrom(
        masterDetailViewControllerDeriviationFuctionType: MasterDetailViewControllerDeriviationFuctionType)
        -> (UIViewController, RouterSeed)
    {
        let (detailController, detaillRouterSeed) = deriveDetailViewControllerFrom(
            detailControllerDeriviationFunctionType: masterDetailViewControllerDeriviationFuctionType.detailFunctionType
        )
        
        let (masterController, masterRouterSeed) = deriveMasterViewControllerFrom(
            detailTransitionsHandlerBox: detaillRouterSeed.transitionsHandlerBox,
            masterControllerDeriviationFunctionType: masterDetailViewControllerDeriviationFuctionType.masterFunctionType
        )
        
        let masterTransitionsHandlerBox = masterRouterSeed.masterTransitionsHandlerBox
        let detailTransitionsHandlerBox = detaillRouterSeed.transitionsHandlerBox
        
        let splitViewController = marshrouteStack.routerControllersProvider.splitViewController()
        
        splitViewController.viewControllers = [masterController, detailController]
        
        let splitTransitionsHandler = marshrouteStack.transitionsHandlersProvider.splitViewTransitionsHandler(
            splitViewController: splitViewController
        )
        
        splitTransitionsHandler.masterTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
        splitTransitionsHandler.detailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
        
        let routerSeed = makeRouterSeed(
            containingTransitionsHandler: splitTransitionsHandler
        )
        
        return (splitViewController, routerSeed)
    }
}
