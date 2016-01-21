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
            else { return }
        
        let backwardContext = BackwardTransitionContext(targetViewController: rootViewController)
        transitionsHandler.undoTransitions(tilContext: backwardContext)
    }
}