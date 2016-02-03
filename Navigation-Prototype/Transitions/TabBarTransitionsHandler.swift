import UIKit

class TabBarTransitionsHandler {
    private unowned let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    var tabTransitionsHandlers: [TransitionsHandler]? {
        didSet {
            assert(tabTransitionsHandlers?.count == tabBarController.viewControllers?.count)
        }
    }
}

// MARK: - TransitionsHandler
extension TabBarTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        selectedTransitionsHandler?.performTransition(context: context)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        if let tabTransitionsHandlers = tabTransitionsHandlers {
            for transitionsHandler in tabTransitionsHandlers {
                transitionsHandler.undoTransitionsAfter(transitionId: transitionId)
            }
        }
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        if let tabTransitionsHandlers = tabTransitionsHandlers {
            for transitionsHandler in tabTransitionsHandlers {
                transitionsHandler.undoTransitionWith(transitionId: transitionId)
            }
        }
    }
    
    func undoAllChainedTransitions() {
        selectedTransitionsHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        selectedTransitionsHandler?.undoAllTransitions()
    }
    
    func resetWithTransition(context context: ForwardTransitionContext) {
        selectedTransitionsHandler?.resetWithTransition(context: context)
    }
}

// MARK: - helpers
extension TabBarTransitionsHandler {
    var selectedTransitionsHandler: TransitionsHandler? {
        let index = tabBarController.selectedIndex
        return (index < tabTransitionsHandlers?.count) ? tabTransitionsHandlers?[index] : nil
    }
}
