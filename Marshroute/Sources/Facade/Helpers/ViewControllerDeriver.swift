public final class ViewControllerDeriver {
    // MARK: - Private properties
    private let routerSeedMaker: SingleTransitionIdRouterSeedMaker
    private let marshrouteStack: MarshrouteStack
    
    // MARK: - Init
    public init(
        routerSeedMaker: SingleTransitionIdRouterSeedMaker,
        marshrouteStack: MarshrouteStack)
    {
        self.routerSeedMaker = routerSeedMaker
        self.marshrouteStack = marshrouteStack
    }
    
    // MARK: - Public
    public func deriveDetailViewControllerFrom(
        detailControllerDeriviationFunctionType: DetailViewControllerDeriviationFunctionType)
        -> (UIViewController, RouterSeed)
    {
        switch detailControllerDeriviationFunctionType {
        case .controller(let deriveDetailViewController):
            return deriveDetailViewControllerFrom(
                deriveDetailViewController: deriveDetailViewController
            )
            
        case .controllerInNavigationController(let deriveDetailViewController):
            let (navigationController, routerSeed) = deriveDetailViewControllerInNavigationControllerFrom(
                deriveDetailViewController: deriveDetailViewController
            )
            return (navigationController, routerSeed)
            // Cannot use `return` in one line due to a `Swift` 4 error: 
            // Cannot express tuple conversion '(UINavigationController, RouterSeed)' to '(UIViewController, RouterSeed)'
        }
    }
    
    public func deriveDetailViewControllerInNavigationControllerFrom(
        deriveDetailViewController: DeriveDetailViewController,
        navigationController: UINavigationController?)
        -> (UIViewController, UINavigationController, RouterSeed)
    {
        let navigationController = navigationController
            ?? marshrouteStack.routerControllersProvider.navigationController()
        
        let navigationTransitionsHandler = marshrouteStack.transitionsHandlersProvider.navigationTransitionsHandler(
            navigationController: navigationController
        )
        
        let routerSeed = routerSeedMaker.makeRouterSeed(
            animatingTransitionsHandler: navigationTransitionsHandler
        )
        
        let viewController = deriveDetailViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            animatingTransitionsHandler: navigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: routerSeed.transitionId
        )
        
        navigationTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return (viewController, navigationController, routerSeed)
    }
    
    public func deriveMasterDetailViewControllerFrom(
        masterDetailViewControllerDeriviationFuctionType: MasterDetailViewControllerDeriviationFuctionType)
        -> (UISplitViewController, RouterSeed)
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
        
        let splitTransitionsHandler = marshrouteStack.transitionsHandlersProvider.splitViewTransitionsHandler()
        
        splitTransitionsHandler.masterTransitionsHandler = masterTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
        splitTransitionsHandler.detailTransitionsHandler = detailTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
        
        let routerSeed = routerSeedMaker.makeRouterSeed(
            containingTransitionsHandler: splitTransitionsHandler
        )
        
        let splitViewController = masterDetailViewControllerDeriviationFuctionType
            .deriveMasterDetailViewController?(routerSeed)
            ?? marshrouteStack.routerControllersProvider.splitViewController()        
        
        splitViewController.viewControllers = [masterController, detailController]
        
        splitTransitionsHandler.setSplitViewController(splitViewController)
        
        return (splitViewController, routerSeed)
    }
    
    public func tabBarModule(
        tabViewControllerDeriviationFunctions: [TabViewControllerDeriviationFunctionType],
        deriveTabBarController: DeriveTabBarController? = nil)
        -> (UITabBarController, [UIViewController], RouterSeed, TabBarTransitionsHandlerImpl)
    {
        // Create tab bar
        let tabTransitionsHandler = marshrouteStack.transitionsHandlersProvider.tabBarTransitionsHandler()
        
        let routerSeed = routerSeedMaker.makeRouterSeed(
            containingTransitionsHandler: tabTransitionsHandler
        )
        
        // Collect tabs when created
        var animatingTransitionsHandlers = [Int: AnimatingTransitionsHandler]()
        var containingTransitionsHandlers = [Int: ContainingTransitionsHandler]()
        var tabControllers = [UIViewController]()
        
        let appendTransitionHandlers = { (_ routerSeed: RouterSeed, _ tabIndex: Int) in
            switch routerSeed.transitionsHandlerBox {
            case .animating(strongBox: let animatingTransitionsHandlerBox):
                animatingTransitionsHandlers[tabIndex] = animatingTransitionsHandlerBox.unbox()
            case .containing(strongBox: let containingTransitionsHandlerBox):
                containingTransitionsHandlers[tabIndex] = containingTransitionsHandlerBox.unbox()
            }
        }
        
        let createTabViewControllers = { [weak self] in
            guard let strongSelf = self else {
                assertionFailure("`createTabViewControllers` must be called synchoronously")
                return
            }
            
            // Create tabs
            for (tabIndex, tabViewControllerDeriviationFunction) in tabViewControllerDeriviationFunctions.enumerated() {
                switch tabViewControllerDeriviationFunction {
                case .detailController(let detailControllerDeriviationFunctionType):
                    let (viewController, routerSeed) = strongSelf.deriveDetailViewControllerFrom(
                        detailControllerDeriviationFunctionType: detailControllerDeriviationFunctionType
                    )
                    tabControllers.append(viewController)
                    appendTransitionHandlers(routerSeed, tabIndex)
                    
                case .masterDetailViewController(let masterDetailViewControllerDeriviationFuctionType):
                    let (viewController, routerSeed) = strongSelf.deriveMasterDetailViewControllerFrom(
                        masterDetailViewControllerDeriviationFuctionType: masterDetailViewControllerDeriviationFuctionType
                    )
                    tabControllers.append(viewController)
                    appendTransitionHandlers(routerSeed, tabIndex)
                }
            }
        }
        
        let tabBarController: UITabBarController
        
        if let deriveTabBarController = deriveTabBarController {
            tabBarController = deriveTabBarController(routerSeed, createTabViewControllers)
        } else {
            tabBarController = marshrouteStack.routerControllersProvider.tabBarController()
            createTabViewControllers()
        }
        
        tabTransitionsHandler.animatingTransitionsHandlers = animatingTransitionsHandlers
        tabTransitionsHandler.containingTransitionsHandlers = containingTransitionsHandlers
        
        tabBarController.viewControllers = tabControllers
        
        tabTransitionsHandler.setTabBarController(tabBarController)
        
        return (tabBarController, tabControllers, routerSeed, tabTransitionsHandler)
    }

    // MARK: - Private
    private func deriveDetailViewControllerFrom(
        deriveDetailViewController: DeriveDetailViewController)
        -> (UIViewController, RouterSeed)
    {
        let animatingTransitionsHandler = marshrouteStack.transitionsHandlersProvider.animatingTransitionsHandler()
        
        let routerSeed = routerSeedMaker.makeRouterSeed(
            animatingTransitionsHandler: animatingTransitionsHandler
        )
        
        let viewController = deriveDetailViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            registeringViewController: viewController,
            animatingTransitionsHandler: animatingTransitionsHandler,
            transitionId: routerSeed.transitionId
        )
        
        animatingTransitionsHandler.resetWithTransition(context: resetContext)
        
        return (viewController, routerSeed)
    }
    
    private func deriveDetailViewControllerInNavigationControllerFrom(
        deriveDetailViewController: DeriveDetailViewController)
        -> (UINavigationController, RouterSeed)
    {
        let (_, navigationController, routerSeed) = deriveDetailViewControllerInNavigationControllerFrom(
            deriveDetailViewController: deriveDetailViewController,
            navigationController: nil
        )
        
        return (navigationController, routerSeed)
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
        
        let routerSeed = routerSeedMaker.makeMasterDetailRouterSeed(
            masterAnimaingTransitionsHandler: animatingMasterTransitionsHandler,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
        
        let viewController = deriveMasterViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            registeringViewController: viewController,
            animatingTransitionsHandler: animatingMasterTransitionsHandler,
            transitionId: routerSeed.transitionId
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
        
        let routerSeed = routerSeedMaker.makeMasterDetailRouterSeed(
            masterAnimaingTransitionsHandler: navigationTransitionsHandler,
            detailTransitionsHandlerBox: detailTransitionsHandlerBox
        )
        
        let viewController = deriveMasterViewController(routerSeed)
        
        let resetContext = ResettingTransitionContext(
            settingRootViewController: viewController,
            forNavigationController: navigationController,
            animatingTransitionsHandler: navigationTransitionsHandler,
            animator: SetNavigationTransitionsAnimator(),
            transitionId: routerSeed.transitionId
        )
        
        navigationTransitionsHandler.resetWithTransition(
            context: resetContext
        )
        
        return (navigationController, routerSeed)
    }
}
