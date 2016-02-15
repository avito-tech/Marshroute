import UIKit

protocol Router: class {

    //MARK: navigation
    
    func presentModalMasterViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func presentModalMasterViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalMasterViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)

    //MARK: popover
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - Router Default Impl
extension Router where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder {
    
    //MARK: navigation
    
    func presentModalMasterViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        presentModalMasterViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func presentModalMasterViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        presentModalMasterViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: animator,
            masterNavigationController: UINavigationController(),
            detailNavigationController: UINavigationController(),
            splitViewController: UISplitViewController()
        )
    }
    
    func presentModalMasterViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        @noescape deriveDetailViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
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
            transitionsCoordinator: transitionsCoordinator)
        
        let detailTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: detailNavigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let masterTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: masterTransitionsHandler)
        let detailTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: detailTransitionsHandler)
        
        let splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinator)
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        // один на master и detail модули. см описание TransitionId
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()

        do {
            let masterRouterSeed = BaseRouterSeed(
                transitionsHandlerBox: masterTransitionsHandlerBox,
                transitionId: generatedTransitionId,
                presentingTransitionsHandler: transitionsHandlerBox.unbox(),
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator)
            
            let masterViewController = deriveMasterViewController(routerSeed: masterRouterSeed)
            
            let resetMasterContext = ForwardTransitionContext(
                resettingWithViewController: masterViewController,
                animatingTransitionsHandler: masterTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId)
            
            masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
        }
        
        do {
            let detailRouterSeed = BaseRouterSeed(
                transitionsHandlerBox: detailTransitionsHandlerBox,
                transitionId: generatedTransitionId,
                presentingTransitionsHandler: transitionsHandlerBox.unbox(),
                transitionsCoordinator: transitionsCoordinator,
                transitionIdGenerator: transitionIdGenerator)
            
            let detailViewController = deriveDetailViewController(routerSeed: detailRouterSeed)
            
            let resetDetailContext = ForwardTransitionContext(
                resettingWithViewController: detailViewController,
                animatingTransitionsHandler: detailTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId)
            
            detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalMasterDetailViewController: splitViewController,
            targetTransitionsHandler: splitViewTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)
        
        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: animator,
            navigationController: UINavigationController()
        )
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let navigationTransitionsHandlerBox = RouterTransitionsHandlerBox(animatingTransitionsHandler: navigationTransitionsHandler)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let routerSeed = BaseRouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: animator,
                transitionId: generatedTransitionId)
            
            navigationTransitionsHandler.resetWithTransition(context: resetContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalViewController: viewController,
            inNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandlerBox.unbox().performTransition(context: modalContext)
    }
    
    //MARK: popover
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator(),
            resetAnimator: NavigationTransitionsAnimator()
        )
    }
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    {
        presentPopoverFromRect(
            rect,
            inView: view,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            resetAnimator: resetAnimator,
            navigationController: UINavigationController()
        )
    }
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
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
        
        let routerSeed = BaseRouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)
        
        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: resetAnimator,
                transitionId: generatedTransitionId)
            
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
            transitionId: generatedTransitionId)

        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: PopoverTransitionsAnimator(),
            resetAnimator: NavigationTransitionsAnimator()
        )
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    {
        presentPopoverFromBarButtonItem(
            barButtonItem,
            withViewControllerDerivedFrom: deriveViewController,
            animator: animator,
            resetAnimator: resetAnimator,
            navigationController: UINavigationController()
        )
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (routerSeed: BaseRouterSeed) -> UIViewController,
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
        
        let routerSeed = BaseRouterSeed(
            transitionsHandlerBox: navigationTransitionsHandlerBox,
            transitionId: generatedTransitionId,
            presentingTransitionsHandler: transitionsHandlerBox.unbox(),
            transitionsCoordinator: transitionsCoordinator,
            transitionIdGenerator: transitionIdGenerator)
        
        let viewController = deriveViewController(routerSeed: routerSeed)

        do {
            let resetContext = ForwardTransitionContext(
                resettingWithViewController: viewController,
                animatingTransitionsHandler: navigationTransitionsHandler,
                animator: resetAnimator,
                transitionId: generatedTransitionId)
            
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
            transitionId: generatedTransitionId)

        transitionsHandlerBox.unbox().performTransition(context: popoverContext)
    }
}