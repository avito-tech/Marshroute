import UIKit

public protocol Router: class {

    //MARK: navigation
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)

    //MARK: popover
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - Router Default Impl
extension Router where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder, Self: RouterControllersProviderHolder {
    
    //MARK: navigation
    
    public func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    public func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: animator,
            masterNavigationController: controllersProvider.navigationController(),
            detailNavigationController: controllersProvider.navigationController(),
            splitViewController: controllersProvider.splitViewController()
        )
    }
    
    public func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: MasterDetailRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let masterTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: masterNavigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let detailTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: detailNavigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let masterTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: masterTransitionsHandler)
        let detailTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: detailTransitionsHandler)
        
        let splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        // один на master и detail модули. см описание TransitionId
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()

        do {
            let masterRouterSeed = MasterDetailRouterSeed(
                masterTransitionsHandlerBox: masterTransitionsHandlerBox,
                detailTransitionsHandlerBox: detailTransitionsHandlerBox,
                transitionId: generatedTransitionId,
                presentingTransitionsHandler: transitionsHandlerBox.unbox(),
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: controllersProvider
            )
            
            let masterViewController = deriveMasterViewController(routerSeed: masterRouterSeed)
            
            let resetMasterContext = ForwardTransitionContext(
                resettingWithViewController: masterViewController,
                animatingTransitionsHandler: masterTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId
            )
            
            masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
        }
        
        do {
            let detailRouterSeed = RouterSeed(
                transitionsHandlerBox: detailTransitionsHandlerBox,
                transitionId: generatedTransitionId,
                presentingTransitionsHandler: transitionsHandlerBox.unbox(),
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator,
                controllersProvider: controllersProvider
            )
            
            let detailViewController = deriveDetailViewController(routerSeed: detailRouterSeed)
            
            let resetDetailContext = ForwardTransitionContext(
                resettingWithViewController: detailViewController,
                animatingTransitionsHandler: detailTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId
            )
            
            detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalMasterDetailViewController: splitViewController,
            targetTransitionsHandler: splitViewTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )
        
        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
    
    public func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }

    public func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: animator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: navigationTransitionsHandler)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalViewController: viewController,
            inNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )

        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
    
    //MARK: popover
    
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator(),
            resetAnimator: NavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            resetAnimator: resetAnimator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator
        )
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: navigationTransitionsHandler)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: resetAnimator,
                transitionId: generatedTransitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
        
        let popoverContext = ForwardTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromRect: rect,
            inView: view,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )

        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator(),
            resetAnimator: NavigationTransitionsAnimator()
        )
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            resetAnimator: resetAnimator,
            navigationController: controllersProvider.navigationController()
        )
    }
    
    public func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: RouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)

        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: navigationTransitionsHandler)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = RouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator,
            controllersProvider: controllersProvider
        )

        
        let viewController = deriveViewController(routerSeed: routerSeed)

        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: resetAnimator,
                transitionId: generatedTransitionId
            )
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let popoverController = UIPopoverController(contentViewController: navigationController)
    
        let popoverContext = ForwardTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId
        )

        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
}