import UIKit

enum Tabs: Int {
    case Main = 0
    case Favorites
    case Profile
    case Channels
    case Publish
}

class TabBarTransitionsHandler {
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    var tabTransitionHandlers: [TransitionsHandler]?
    
    func selectTab(tab: Tabs) {
        guard let controllers = tabBarController.viewControllers
            else { return }
        
        let index = tab.rawValue
        if index < controllers.count {
            tabBarController.selectedIndex = index
        }
    }
}

// MARK: - TransitionsHandler
extension TabBarTransitionsHandler: TransitionsHandler {
    func performTransition(context context: ForwardTransitionContext) {
        selectedTransitionHandler?.performTransition(context: context)
    }
    
    func undoTransitions(tilContext context: BackwardTransitionContext) {
        selectedTransitionHandler?.undoTransitions(tilContext: context)
    }
    
    func undoAllChainedTransitions() {
        selectedTransitionHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        selectedTransitionHandler?.undoAllTransitions()
    }
    
    func undoAllChainedTransitionsAndResetWithTransition(context: ForwardTransitionContext) {
        selectedTransitionHandler?.undoAllChainedTransitionsAndResetWithTransition(context)
    }
}

// MARK: - helpers
extension TabBarTransitionsHandler {
    var selectedTransitionHandler: TransitionsHandler? {
        let index = tabBarController.selectedIndex
        return (index < tabTransitionHandlers?.count) ? tabTransitionHandlers?[index] : nil
    }
}
