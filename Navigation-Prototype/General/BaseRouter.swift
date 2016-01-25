import UIKit

class BaseRouter: Router, TransitionsHandlerStorer, RouterDismisable {
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
    weak var parentRouter: RouterDismisable?
    
    func dismissChildRouter(child: RouterDismisable) {
        focusTransitionsHandlerBackOnMyRootViewController()
    }
}

extension BaseRouter {
    func focusTransitionsHandlerBackOnMyRootViewController()
    {
        guard let rootViewController = rootViewController
            else { assert(false); return }
        
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let backwardContext = BackwardTransitionContext(targetViewController: rootViewController)
        transitionsHandler.undoTransitions(tilContext: backwardContext)
    }
    
    func pushViewController(viewController: UIViewController,
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
    
    func presentModalMasterDetailViewController(
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
    
    func presentModalSplitViewController(
        viewController: UISplitViewController,
        masterControllerDerivedFromClosure closureMaster: (TransitionsHandler -> UIViewController),
        detailControllerDerivedFromClosure closureDetail: (TransitionsHandler -> UIViewController),
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        let splitViewController = UISplitViewController()
        let splitViewTransitionHandler = splitViewController.wrappedInSplitViewTransitionsHandler()
        defer {
            presentModalMasterDetailViewController(
                splitViewController,
                targetTransitionsHandler: splitViewTransitionHandler,
                animator: animator
            )
        }
        
        let masterNavigation = UINavigationController()
        let detailNavigation = UINavigationController()
        splitViewController.viewControllers = [masterNavigation, detailNavigation]
        
        let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
        let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()

        splitViewTransitionHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionHandler.detailTransitionsHandler = detailTransitionsHandler
        
        let masterViewController = closureMaster(masterTransitionsHandler)
        let detailViewController = closureDetail(detailTransitionsHandler)

        masterNavigation.viewControllers = [masterViewController]
        detailNavigation.viewControllers = [detailViewController]
    }
    
    func presentModalViewController(
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
    
    func presentModalViewControllerDerivedFrom(closure closure: (TransitionsHandler -> UIViewController),
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
    
    func presentViewController(
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
    
    
    func presentViewControllerDerivedFrom(
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
    
    func presentViewController(
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
    
    func presentViewControllerDerivedFrom(
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