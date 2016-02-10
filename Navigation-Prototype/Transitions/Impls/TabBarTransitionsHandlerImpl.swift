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
    
    var tabTransitionsHandlers: [TransitionsHandler]? {
        didSet {
            if let tabBarController = tabBarController {
                assert(tabTransitionsHandlers?.count == tabBarController.viewControllers?.count)
            }
        }
    }
}

// MARK: - TransitionsHandler
extension TabBarTransitionsHandlerImpl: TransitionsHandler { }

//MARK: - TransitionsCoordinatorHolder
extension TabBarTransitionsHandlerImpl: TransitionsCoordinatorHolder {}

//MARK: - TransitionsHandlerContainer
extension TabBarTransitionsHandlerImpl: TransitionsHandlerContainer {
    var allTransitionsHandlers: [TransitionsHandler]? {
        return tabTransitionsHandlers
    }
    
    var visibleTransitionsHandlers: [TransitionsHandler]? {
        if let selectedTransitionsHandler = selectedTransitionsHandler {
            return [selectedTransitionsHandler]
        }
        return nil
    }
}

// MARK: - helpers
private extension TabBarTransitionsHandlerImpl {
    var selectedTransitionsHandler: TransitionsHandler? {
        if let tabTransitionsHandlers = tabTransitionsHandlers, let selectedIndex = tabBarController?.selectedIndex
            where selectedIndex < tabTransitionsHandlers.count
        {
            return tabTransitionsHandlers[selectedIndex]
        }
        return nil
    }
}