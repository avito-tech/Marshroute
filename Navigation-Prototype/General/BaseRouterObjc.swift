import Foundation
import UIKit

@objc class BaseRouterObjc: NSObject {
    // Router
    private weak var rootViewControllerPrivate: UIViewController?
    
    // TransitionsHandlerStorage
    private var transitionsHandlerPrivate: TransitionsHandler?
    
    // RouterDismisable
    private weak var parentRouterPrivate: RouterDismisable?
}

// MARK: - Router
extension BaseRouterObjc: Router {
    weak var rootViewController: UIViewController? {
        return rootViewControllerPrivate
    }
    
    final func setRootViewControllerIfNeeded(controller: UIViewController) {
        if rootViewControllerPrivate == nil {
            rootViewControllerPrivate = controller
        }
    }
}

// MARK: - TransitionsHandlerStorage
extension BaseRouterObjc: TransitionsHandlerStorage {
    var transitionsHandler: TransitionsHandler? {
        get { return transitionsHandlerPrivate }
        set { transitionsHandlerPrivate = newValue }
    }
}

// MARK: - RouterDismisable
extension BaseRouterObjc: RouterDismisable {
    weak var parentRouter: RouterDismisable? {
        get { return parentRouterPrivate }
        set { parentRouterPrivate = newValue }
    }
    
    func dismissChildRouter(child: RouterDismisable) {}
}

// MARK: - helpers
extension BaseRouterObjc {
    final func focusTransitionsHandlerBackOnMyRootViewController() {
        guard let rootViewController = rootViewController
            else { return }
        
        guard let transitionsHandler = transitionsHandler
            else { return }
        
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
    
    func presentModalViewController(
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
    
    func presentModalViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        navigationTransitionsHandler: TransitionsHandler? = nil,
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let targetTransitionsHandler = navigationTransitionsHandler
            ?? navigationController.wrappedInNavigationTransitionsHandler()
        
        guard targetTransitionsHandler !== transitionsHandler
            else { assert(false, "you must create a new Navigation Transitions Handler for modal transitions"); return }
        
        let context = ForwardTransitionContext(
            presentingModalViewController: viewController,
            inNavigationController: navigationController,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    }
    
    func presentViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromRect rect: CGRect,
        inView view: UIView,
        navigationTransitionsHandler: TransitionsHandler? = nil,
        animator: TransitionsAnimator = PopoverTranstionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let targetTransitionsHandler = navigationTransitionsHandler
            ?? navigationController.wrappedInNavigationTransitionsHandler()
        
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
    
    func presentViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        inPopoverController popoverController: UIPopoverController,
        fromBarButtonItem buttonItem: UIBarButtonItem,
        navigationTransitionsHandler: TransitionsHandler? = nil,
        animator: TransitionsAnimator = PopoverTranstionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
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
}