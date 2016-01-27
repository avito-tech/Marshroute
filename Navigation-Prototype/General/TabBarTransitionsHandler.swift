import UIKit

//TODO: aaa убрать отсюда
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
    func performTransition(@noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext) {
        selectedTransitionHandler?.performTransition(contextCreationClosure: closure)
    }
    
    func undoTransitions(tilTransitionId transitionId: TransitionId) {
        selectedTransitionHandler?.undoTransitions(tilTransitionId: transitionId)
    }
    
    func undoTransitions(tilTransitionIdPreceding transitionId: TransitionId) {
        selectedTransitionHandler?.undoTransitions(tilTransitionIdPreceding: transitionId)
    }
    
    func undoAllChainedTransitions() {
        selectedTransitionHandler?.undoAllChainedTransitions()
    }
    
    func undoAllTransitions() {
        selectedTransitionHandler?.undoAllTransitions()
    }
    
    func resetWithTransition(
        @noescape contextCreationClosure closure: (generatedTransitionId: TransitionId) -> ForwardTransitionContext)
    {
        selectedTransitionHandler?.resetWithTransition(contextCreationClosure: closure)
    }
}

// MARK: - helpers
extension TabBarTransitionsHandler {
    var selectedTransitionHandler: TransitionsHandler? {
        let index = tabBarController.selectedIndex
        return (index < tabTransitionHandlers?.count) ? tabTransitionHandlers?[index] : nil
    }
}
