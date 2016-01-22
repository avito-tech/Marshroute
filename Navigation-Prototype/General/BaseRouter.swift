import UIKit

class BaseRouter: Router, TransitionsHandlerStorage, RouterDismisable {
    // Router
    private (set) weak var rootViewController: UIViewController?
    
    final func setRootViewControllerIfNeeded(controller: UIViewController) {
        if rootViewController == nil {
            rootViewController = controller
        }
    }
    
    // TransitionsHandlerStorage
    var transitionsHandler: TransitionsHandler?
    
    // RouterDismisable
    weak var parentRouter: RouterDismisable?

    func dismissChildRouter(child: RouterDismisable) { }
}

extension BaseRouter {
    func focusTransitionsHandlerBackOnMyRootViewController() {
        guard let rootViewController = rootViewController
            else { return }
        
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
    
    func presentModalViewController(
        viewController: UIViewController,
        inNavigationController navigationController: UINavigationController,
        navigationTransitionsHandler: TransitionsHandler? = nil,
        animator: TransitionsAnimator = NavigationTransitionsAnimator())
    {
        guard let transitionsHandler = transitionsHandler
            else { assert(false); return }
        
        let targetTransitionsHandler = navigationTransitionsHandler ?? navigationController.wrappedInNavigationTransitionsHandler()

        let animator = NavigationTransitionsAnimator()
        
        let context = ForwardTransitionContext(
            presentingModalViewController: viewController,
            wrappedInNavigationController: navigationController,
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
        
        let animator = NavigationTransitionsAnimator()
        
        let context = ForwardTransitionContext(
            presentingModalViewController: viewController,
            targetTransitionsHandler: targetTransitionsHandler,
            parentTransitionsHandler: <#T##TransitionsHandler#>, animator: <#T##TransitionsAnimator#>)
        
        let context = ForwardTransitionContext(
            presentingModalViewController: viewController,
            targetTransitionsHandler: targetTransitionsHandler,
            animator: animator)
        
        transitionsHandler.performTransition(context: context)
    
    
    
    
    
    }
    
    
    
    
    
    
    
    
    
}