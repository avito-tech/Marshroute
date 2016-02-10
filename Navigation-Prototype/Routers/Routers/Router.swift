import UIKit

protocol Router: class {
    //MARK: navigation
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator,
        navigationController: UINavigationController)

    //MARK: popover
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - Router Default Impl
extension Router where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionsGeneratorStorer, Self: TransitionsCoordinatorStorer {
    //MARK: navigation
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandler: transitionsHandler)
        
        let pushContext = ForwardTransitionContext(
            pushingViewController: viewController,
            targetTransitionsHandler: transitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandler.performTransition(context: pushContext)
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: animator,
            masterNavigationController: UINavigationController(),
            detailNavigationController: UINavigationController(),
            splitViewController: UISplitViewController()
        )
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
        let masterTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: masterNavigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let detailTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: detailNavigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let splitViewTransitionsHandler = SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: transitionsCoordinator)
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()

        do {
            let masterViewController = deriveMasterViewController(
                transitionId: transitionId,
                transitionsHandler: masterTransitionsHandler)
            
            let resetMasterContext = ForwardTransitionContext(
                resetingWithViewController: masterViewController,
                transitionsHandler: masterTransitionsHandler,
                animator: animator,
                transitionId: transitionId)
            
            masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
        }
        
        do {
            let detailViewController = deriveDetailViewController(
                transitionId: generatedTransitionId,
                transitionsHandler: detailTransitionsHandler)
            
            let resetDetailContext = ForwardTransitionContext(
                resetingWithViewController: detailViewController,
                transitionsHandler: detailTransitionsHandler,
                animator: animator,
                transitionId: transitionId)
            
            detailTransitionsHandler.resetWithTransition(context: resetDetailContext)
        }
        
        let modalContext = ForwardTransitionContext(
            presentingModalMasterDetailViewController: splitViewController,
            targetTransitionsHandler: splitViewTransitionsHandler,
            animator: animator,
            transitionId: generatedTransitionId)

         transitionsHandler.performTransition(context: modalContext)
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: animator,
            navigationController: UINavigationController()
        )
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BaseNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        do {
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: navigationTransitionsHandler,
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

        transitionsHandler.performTransition(context: modalContext)
    }
    
    //MARK: popover
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator)
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        do {
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: navigationTransitionsHandler,
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

        transitionsHandler.performTransition(context: popoverContext)
    }
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator)
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: BasePopoverTransitionsAnimator,
        resetAnimator: BaseNavigationTransitionsAnimator,
        navigationController: UINavigationController)
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let navigationTransitionsHandler = NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: transitionsCoordinator)

        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandler: navigationTransitionsHandler)
        
        do {
            let resetContext = ForwardTransitionContext(
                resetingWithViewController: viewController,
                transitionsHandler: navigationTransitionsHandler,
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

        transitionsHandler.performTransition(context: popoverContext)
    }
}