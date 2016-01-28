import UIKit

class TabBarTransitionsHandler {
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    var tabTransitionHandlers: [TransitionsHandler]?
}

// MARK: - TransitionsHandler
extension TabBarTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        selectedTransitionHandler?.performTransition(context: context)
    }
    
    func undoTransitionsAfter(transitionId transitionId: TransitionId) {
        selectedTransitionHandler?.undoTransitionsAfter(transitionId: transitionId)
    }
    
    func undoTransitionWith(transitionId transitionId: TransitionId) {
        selectedTransitionHandler?.undoTransitionWith(transitionId: transitionId)
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
