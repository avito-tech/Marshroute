import UIKit

class BaseRouter: Router, RouterDismisable, RouterFocusable, TransitionsHandlerStorer {
    // Router
    private (set) weak var rootViewController: UIViewController?
    
    final func setRootViewControllerIfNeeded(controller: UIViewController) {
        if rootViewController == nil {
            rootViewController = controller
        }
    }
    
    // TransitionsHandlerStorer
    var transitionsHandler: TransitionsHandler?
    
    // RouterDismisable
    weak var presentingTransitionsHandler: TransitionsHandler?
    
    var transitionId: TransitionId?
}

// MARK: - RouterFocusable
extension BaseRouter {
    func focusOnSelf()
    {
        guard let rootViewController = rootViewController
            else { assert(false); return }
        
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let backwardContext = BackwardTransitionContext(targetViewController: rootViewController)
        transitionsHandler.undoTransitions(tilContext: backwardContext)
    }
    
}

// MARK: - helpers
extension BaseRouter {
    final func pushViewController(viewController: UIViewController,
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let targetTransitionsHandler = transitionsHandler
        
        let context = ForwardTransitionContext(
            pushingViewController: viewController,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    }
    
    final func presentModalMasterDetailViewController(
        viewController: UIViewController,
        targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        guard targetTransitionsHandler !== transitionsHandler
            else { assert(false, "you must create a new Transitions Handler for modal transitions"); return }
        
        let context = ForwardTransitionContext(
            presentingModalViewController: viewController,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    }
    
    final func presentModalSplitViewController(
        viewController: UISplitViewController,
        masterControllerDerivedFromClosure closureMaster: (TransitionsHandler -> UIViewController),
        detailControllerDerivedFromClosure closureDetail: (TransitionsHandler -> UIViewController),
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        let splitViewController = UISplitViewController()
        let splitViewTransitionsHandler = splitViewController.wrappedInSplitViewTransitionsHandler()

        let masterNavigation = UINavigationController()
        let detailNavigation = UINavigationController()
        splitViewController.viewControllers = [masterNavigation, detailNavigation]
        
        let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
        let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()

        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        let masterViewController = closureMaster(masterTransitionsHandler)
        let detailViewController = closureDetail(detailTransitionsHandler)

        masterNavigation.viewControllers = [masterViewController]
        detailNavigation.viewControllers = [detailViewController]

        presentModalMasterDetailViewController(
            splitViewController,
            targetTransitionsHandler: splitViewTransitionsHandler,
            animator: animator
        )
    }
    
    final func presentModalViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        navigationTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        guard !(viewController is UISplitViewController)
            else { assert(false); return }
        
        guard !(viewController is UITabBarController)
            else { assert(false); return }
        
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        guard navigationController.viewControllers.contains(viewController)
            else { assert(false); return }
        
        guard navigationTransitionsHandler !== transitionsHandler
            else { assert(false, "you must create a new Navigation Transitions Handler for modal transitions"); return }
        
        let context = ForwardTransitionContext(
            presentingModalViewController: viewController,
            inNavigationController: navigationController,
            targetTransitionsHandler: navigationTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    }
    
    final func presentModalViewControllerDerivedFrom(closure closure: (TransitionsHandler -> UIViewController),
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        // не UISplitViewController, не UITabBarController
        let viewController = closure(transitionsHandler)
        navigationController.viewControllers = [viewController]
        
        presentModalViewController(
            viewController,
            inNavigationController: navigationController,
            navigationTransitionsHandler: transitionsHandler)
    }
    
    final func presentViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromRect rect: CGRect,
        inView view: UIView,
        navigationTransitionsHandler targetTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator = PopoverTranstionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        guard targetTransitionsHandler !== transitionsHandler
            else { assert(false, "you must create a new Navigation Transitions Handler for popover transitions"); return }
        
        let context = ForwardTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromRect: rect,
            inView: view,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    }
    
    
    final func presentViewControllerDerivedFrom(
        closure closure: (TransitionsHandler -> UIViewController),
        inPopoverFromRect rect: CGRect,
        inView view: UIView)
    {
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = closure(transitionsHandler)
        navigationController.viewControllers = [viewController]
        
        let popoverController = navigationController.wrappedInPopoverController()
        
        presentViewController(
            viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromRect: rect,
            inView: view,
            navigationTransitionsHandler: transitionsHandler)
    }
    
    final func presentViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromBarButtonItem buttonItem: UIBarButtonItem,
        navigationTransitionsHandler: TransitionsHandler,
        animator: TransitionsAnimator = PopoverTranstionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        guard navigationController.viewControllers.contains(viewController)
            else { assert(false); return }
        
        let targetTransitionsHandler = navigationTransitionsHandler
            ?? navigationController.wrappedInNavigationTransitionsHandler()
        
        guard targetTransitionsHandler !== transitionsHandler
            else { assert(false, "you must create a new Navigation Transitions Handler for popover transitions"); return }
        
        let context = ForwardTransitionContext(
            presentingViewController: viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: buttonItem,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    }
    
    final func presentViewControllerDerivedFrom(
        closure closure: (TransitionsHandler -> UIViewController),
        inPopoverFromBarButtonItem barButtonItem: UIBarButtonItem)
    {
        let navigationController = UINavigationController()
        let transitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        let viewController = closure(transitionsHandler)
        navigationController.viewControllers = [viewController]
        
        let popoverController = navigationController.wrappedInPopoverController()
        
        presentViewController(
            viewController,
            inNavigationController: navigationController,
            inPopoverController: popoverController,
            fromBarButtonItem: barButtonItem,
            navigationTransitionsHandler: transitionsHandler)
    }
}