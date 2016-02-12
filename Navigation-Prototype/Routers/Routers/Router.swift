import UIKit

protocol Router: class {
    //MARK: navigation
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        masterNavigationController: UINavigationController,
        detailNavigationController: UINavigationController,
        splitViewController: UISplitViewController)

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)

    //MARK: popover
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    
    func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator)
    
    func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: PopoverTransitionsAnimator,
        resetAnimator: NavigationTransitionsAnimator,
        navigationController: UINavigationController)
}

// MARK: - Router Default Impl
extension Router where Self: RouterTransitionable, Self: RouterIdentifiable, Self: TransitionIdGeneratorHolder, Self: TransitionsCoordinatorHolder {
    //MARK: navigation
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    {
        pushViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func pushViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        guard let transitionsHandlerBox = transitionsHandlerBox
            else { assert(false); return }
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandlerBox: transitionsHandlerBox)
        
        let pushContext = ForwardTransitionContext(
            pushingViewController: viewController,
            animator: animator,
            transitionId: generatedTransitionId)

        transitionsHandlerBox.unbox().performTransition(context: pushContext)
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            deriveMasterViewController: deriveMasterViewController,
            deriveDetailViewController: deriveDetailViewController,
            animator: NavigationTransitionsAnimator()
        )
    }
    
    func presentModalMasterDetailViewControllerDerivedFrom(
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
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
        @noescape deriveMasterViewController deriveMasterViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        @noescape deriveDetailViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
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
        
        let generatedTransitionId = transitionIdGenerator.generateNewTransitionId()

        do {
            let masterViewController = deriveMasterViewController(
                transitionId: transitionId,
                transitionsHandlerBox: masterTransitionsHandlerBox)
            
            let resetMasterContext = ForwardTransitionContext(
                resettingWithViewController: masterViewController,
                animatingTransitionsHandler: masterTransitionsHandler,
                animator: animator,
                transitionId: transitionId)
            
            masterTransitionsHandler.resetWithTransition(context: resetMasterContext)
        }
        
        do {
            let detailViewController = deriveDetailViewController(
                transitionId: generatedTransitionId,
                transitionsHandlerBox: detailTransitionsHandlerBox)
            
            let resetDetailContext = ForwardTransitionContext(
                resettingWithViewController: detailViewController,
                animatingTransitionsHandler: detailTransitionsHandler,
                animator: animator,
                transitionId: transitionId)
            
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
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: NavigationTransitionsAnimator()
        )
    }

    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
        animator: NavigationTransitionsAnimator)
    {
        presentModalViewControllerDerivedFrom(
            deriveViewController,
            animator: animator,
            navigationController: UINavigationController()
        )
    }
    
    func presentModalViewControllerDerivedFrom(
        @noescape deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
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
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandlerBox: navigationTransitionsHandlerBox)
        
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
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
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandlerBox: navigationTransitionsHandlerBox)
        
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController)
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
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
        @noescape withViewControllerDerivedFrom deriveViewController: (transitionId: TransitionId, transitionsHandlerBox: RouterTransitionsHandlerBox) -> UIViewController,
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
        
        let viewController = deriveViewController(
            transitionId: generatedTransitionId,
            transitionsHandlerBox: navigationTransitionsHandlerBox)
        
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