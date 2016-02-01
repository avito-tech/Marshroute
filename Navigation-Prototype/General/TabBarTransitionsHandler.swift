import UIKit

class TabBarTransitionsHandler {
    private unowned let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    var tabTransitionHandlers: [TransitionsHandler]? {
        didSet {
            assert(tabTransitionHandlers?.count == tabBarController.viewControllers?.count)
        }
    }
}

// MARK: - TransitionsHandler
extension TabBarTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        selectedTransitionHandler?.performTransition(context: context)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        if let tabTransitionHandlers = tabTransitionHandlers {
            for transitionsHandler in tabTransitionHandlers {
                transitionsHandler.undoTransitionsAfter(transitionId: transitionId)
            }
        }
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        if let tabTransitionHandlers = tabTransitionHandlers {
            for transitionsHandler in tabTransitionHandlers {
                transitionsHandler.undoTransitionWith(transitionId: transitionId)
            }
        }
    }
    
    func undoAllChainedTransitions() {
        selectedTransitionHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        selectedTransitionHandler?.undoAllTransitions()
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        selectedTransitionHandler?.resetWithTransition(context: context)
    }
}

// MARK: - helpers
extension TabBarTransitionsHandler {
    var selectedTransitionHandler: TransitionsHandler? {
        let index = tabBarController.selectedIndex
        return (index < tabTransitionHandlers?.count) ? tabTransitionHandlers?[index] : nil
    }
}
