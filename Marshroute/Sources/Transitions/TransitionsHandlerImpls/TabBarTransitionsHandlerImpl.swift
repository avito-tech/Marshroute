import UIKit
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

final public class TabBarTransitionsHandlerImpl: ContainingTransitionsHandler {
    fileprivate weak var tabBarController: UITabBarController?
    
    public init(tabBarController: UITabBarController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.tabBarController = tabBarController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }
    
    public var animatingTransitionsHandlers: [Int: AnimatingTransitionsHandler]?
    public var containingTransitionsHandlers: [Int: ContainingTransitionsHandler]?

    // MARK: - TransitionsHandlerContainer
    override public var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        guard let tabsCount = tabBarController?.viewControllers?.count, tabsCount > 0
            else { return nil }

        return animatingTransitionsHandlers(
            fromTabIndex: 0,
            toTabIndex: tabsCount,
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                return containingTransitionsHandler.allTransitionsHandlers
            }
        )
    }
    
    override public var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        guard tabBarController?.viewControllers?.count > 0
            else { return nil }
        guard let selectedIndex = tabBarController?.selectedIndex
            else { return nil }
        
        return animatingTransitionsHandlers(
            fromTabIndex: selectedIndex,
            toTabIndex: selectedIndex + 1,
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // у видимого вложенного содержащего обработчика спрашиваем всех обработчиков, а не видимых
                return containingTransitionsHandler.allTransitionsHandlers
        })
    }
}

// MARK: - helpers
private extension TabBarTransitionsHandlerImpl {
    func animatingTransitionsHandlers(
        fromTabIndex: Int,
        toTabIndex: Int,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> [AnimatingTransitionsHandler]
    {
        var result = [AnimatingTransitionsHandler]()
        
        for index in fromTabIndex..<toTabIndex {
            if let animatingTransitionsHandler = animatingTransitionsHandlers?[index] {
                result.append(animatingTransitionsHandler)
            }
            
            if let containingTransitionsHandler = containingTransitionsHandlers?[index] {
                if let childAnimatingTransitionHandlers = unboxContainingTransitionsHandler(containingTransitionsHandler) {
                    result.append(contentsOf: childAnimatingTransitionHandlers)
                }
            }
        }
        
        return result
    }
}
