import UIKit

class SplitViewTransitionsHandler {
    private unowned let splitViewController: UISplitViewController
    private let transitionsCoordinatorPrivate: TransitionsCoordinator
    
    init(splitViewController: UISplitViewController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.splitViewController = splitViewController
        self.transitionsCoordinatorPrivate = transitionsCoordinator
    }
    
    var masterTransitionsHandler: TransitionsHandler?
    var detailTransitionsHandler: TransitionsHandler?
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandler: TransitionsHandler { }

//MARK: - TransitionsCoordinatorStorer
extension SplitViewTransitionsHandler: TransitionsCoordinatorStorer {
    var transitionsCoordinator: TransitionsCoordinator {
        return transitionsCoordinatorPrivate
    }
}

//MARK: - TransitionsHandlersContainer
extension SplitViewTransitionsHandler: TransitionsHandlersContainer {
    var allTransitionsHandlers: [TransitionsHandler]? {
        return transitionsHandlers
    }
    
    var visibleTransitionsHandlers: [TransitionsHandler]? {
        return transitionsHandlers
    }
}

// MARK: - helpers
private extension SplitViewTransitionsHandler {
    var transitionsHandlers: [TransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].flatMap { $0 }
    }
}