import UIKit

final class TabBarTransitionsHandlerImpl {
    private weak var tabBarController: UITabBarController?

    let transitionsCoordinator: TransitionsCoordinator
    
    init(tabBarController: UITabBarController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.tabBarController = tabBarController
        self.transitionsCoordinator = transitionsCoordinator
    }
    
    var animatingTransitionsHandlers: [Int: AnimatingTransitionsHandler]?
    var containingTransitionsHandlers: [Int: ContainingTransitionsHandler]?
}

// MARK: - TransitionsHandler
extension TabBarTransitionsHandlerImpl: TransitionsHandler { }

//MARK: - TransitionsCoordinatorHolder
extension TabBarTransitionsHandlerImpl: TransitionsCoordinatorHolder {}

//MARK: - TransitionsHandlerContainer
extension TabBarTransitionsHandlerImpl: TransitionsHandlerContainer {
    var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        guard let tabsCount = tabBarController?.viewControllers?.count where tabsCount > 0
            else { return nil }

        return animatingTransitionsHandlersPerEveryTab(
            fromTabIndex: 0,
            toTabIndex: tabsCount,
            containingTransitionsHandlersProcessor: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                return containingTransitionsHandler.allTransitionsHandlers
            }
        )
    }
    
    var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        guard tabBarController?.viewControllers?.count > 0
            else { return nil }
        guard let selectedIndex = tabBarController?.selectedIndex
            else { return nil }
        
        return animatingTransitionsHandlersPerEveryTab(
            fromTabIndex: selectedIndex,
            toTabIndex: selectedIndex + 1,
            containingTransitionsHandlersProcessor: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                return containingTransitionsHandler.allTransitionsHandlers
        })
    }
}

// MARK: - helpers
private extension TabBarTransitionsHandlerImpl {
    func animatingTransitionsHandlersPerEveryTab(
        fromTabIndex fromTabIndex: Int,
        toTabIndex: Int,
        containingTransitionsHandlersProcessor: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> [AnimatingTransitionsHandler]
    {
        var result = [AnimatingTransitionsHandler]()
        
        for index in fromTabIndex..<toTabIndex {
            if let animatingTransitionsHandler = animatingTransitionsHandlers?[index] {
                result.append(animatingTransitionsHandler)
            }
            
            if let containingTransitionsHandler = containingTransitionsHandlers?[index] {
                if let childAnimatingTransitionHandlers = containingTransitionsHandlersProcessor(containingTransitionsHandler) {
                    result.appendContentsOf(childAnimatingTransitionHandlers)
                }
            }
        }
        
        return result
    }
}