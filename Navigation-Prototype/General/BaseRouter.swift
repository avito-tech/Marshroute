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
    var transitionsHandler: TransitionsHandler
    
    // RouterDismisable
    weak var parentTransitionsHandler: TransitionsHandler?
    
    var transitionId: TransitionId?
    
    init(transitionsHandler: TransitionsHandler, transitionId: TransitionId?, parentTransitionsHandler: TransitionsHandler?) {
        self.transitionId = transitionId
        self.transitionsHandler = transitionsHandler
        self.parentTransitionsHandler = parentTransitionsHandler
    }
}

// MARK: - RouterFocusable
extension BaseRouter {
    func focusOnSelf()
    {
        guard let rootViewController = rootViewController
            else { assert(false); return }
        
        let backwardContext = BackwardTransitionContext(targetViewController: rootViewController)
        transitionsHandler.undoTransitions(tilContext: backwardContext)
    }
    
}

// MARK: - helpers
extension BaseRouter {
    final func pushViewControllerDerivedFrom(
        closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        pushViewControllerDerivedFrom(closure, animator: NavigationTransitionsAnimator())
    }
    
    final func pushViewControllerDerivedFrom(
        closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let targetTransitionsHandler = transitionsHandler
        
        transitionsHandler.performTransition(contextCreationClosure: { (generatedTransitionId: TransitionId) -> ForwardTransitionContext in
            let viewController = closure(
                transitionId: generatedTransitionId,
                transitionsHandler: targetTransitionsHandler)
            
            let context = ForwardTransitionContext(
                pushingViewController: viewController,
                targetTransitionsHandler: targetTransitionsHandler,
                animator: animator)
            
            return context
        })
    }

    final func presentModalMasterDetailViewControllerDerivedFrom(
        masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
        
    {
        presentModalMasterDetailViewControllerDerivedFrom(
            masterDeriviationClosure: masterClosure,
            detailDeriviationClosure: detailClosure,
            animator: NavigationTransitionsAnimator())
    }
    
    final func presentModalMasterDetailViewControllerDerivedFrom(
        masterDeriviationClosure masterClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        detailDeriviationClosure detailClosure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let masterNavigation = UINavigationController()
        let detailNavigation = UINavigationController()
        
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigation, detailNavigation]
        
        let masterTransitionsHandler = masterNavigation.wrappedInNavigationTransitionsHandler()
        let detailTransitionsHandler = detailNavigation.wrappedInNavigationTransitionsHandler()
        let splitViewTransitionsHandler = splitViewController.wrappedInSplitViewTransitionsHandler()
        
        splitViewTransitionsHandler.masterTransitionsHandler = masterTransitionsHandler
        splitViewTransitionsHandler.detailTransitionsHandler = detailTransitionsHandler
        
        transitionsHandler.performTransition { (generatedTransitionId: TransitionId) -> ForwardTransitionContext in
            let masterViewController = masterClosure(
                transitionId: generatedTransitionId,
                transitionsHandler: masterTransitionsHandler)
            
            let detailViewController = detailClosure(
                transitionId: generatedTransitionId,
                transitionsHandler: detailTransitionsHandler)
            
            masterNavigation.viewControllers = [masterViewController]
            detailNavigation.viewControllers = [detailViewController]

            let context = ForwardTransitionContext(
                presentingModalViewController: splitViewController,
                targetTransitionsHandler: splitViewTransitionsHandler,
                animator: animator)
            
            return context
        }
    }
    
    final func presentModalViewControllerDerivedFrom(
        closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController)
    {
        presentModalViewControllerDerivedFrom(
            closure,
            animator: NavigationTransitionsAnimator())
    }
    
    final func presentModalViewControllerDerivedFrom(
        closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator)
    {
        let navigationController = UINavigationController()
        let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        transitionsHandler.performTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let viewController = closure(
                transitionId: generatedTransitionId,
                transitionsHandler: navigationTransitionsHandler)
            
            guard !(viewController is UISplitViewController)
                else { assert(false) }
            
            guard !(viewController is UITabBarController)
                else { assert(false) }
            
            navigationController.viewControllers = [viewController]
            
            let context = ForwardTransitionContext(
                presentingModalViewController: viewController,
                inNavigationController: navigationController,
                targetTransitionsHandler: navigationTransitionsHandler,
                animator: animator)
            
            return context
        }
    }
    
    final func presentPopoverFromRect(
        rect: CGRect,
        inView view: UIView,
        withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator = PopoverTranstionsAnimator())
    {
        let navigationController = UINavigationController()
        let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        transitionsHandler.performTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let popoverController = navigationController.wrappedInPopoverController()
            
            let viewController = closure(
                transitionId: generatedTransitionId,
                transitionsHandler: navigationTransitionsHandler)
            
            navigationController.viewControllers = [viewController]
            
            let context = ForwardTransitionContext(
                presentingViewController: viewController,
                inNavigationController: navigationController,
                inPopoverController: popoverController,
                fromRect: rect,
                inView: view,
                targetTransitionsHandler: navigationTransitionsHandler,
                animator: animator)
            
            return context
        }
    }
    
    final func presentPopoverFromBarButtonItem(
        barButtonItem: UIBarButtonItem,
        withViewControllerDerivedFrom closure: (transitionId: TransitionId, transitionsHandler: TransitionsHandler) -> UIViewController,
        animator: TransitionsAnimator = PopoverTranstionsAnimator())
    {
        let navigationController = UINavigationController()
        let navigationTransitionsHandler = navigationController.wrappedInNavigationTransitionsHandler()
        
        transitionsHandler.performTransition { (generatedTransitionId) -> ForwardTransitionContext in
            let popoverController = navigationController.wrappedInPopoverController()
            
            let viewController = closure(
                transitionId: generatedTransitionId,
                transitionsHandler: navigationTransitionsHandler
            )
            
            navigationController.viewControllers = [viewController]
            
            let context = ForwardTransitionContext(
                presentingViewController: viewController,
                inNavigationController: navigationController,
                inPopoverController: popoverController,
                fromBarButtonItem: barButtonItem,
                targetTransitionsHandler: navigationTransitionsHandler,
                animator: animator)

            return context
        }
    }
}