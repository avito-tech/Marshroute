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
}