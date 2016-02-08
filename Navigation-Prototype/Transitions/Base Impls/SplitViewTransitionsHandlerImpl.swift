import UIKit

final class SplitViewTransitionsHandlerImpl {
    private weak var splitViewController: UISplitViewController?
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
extension SplitViewTransitionsHandlerImpl: TransitionsHandler { }

//MARK: - TransitionsCoordinatorStorer
extension SplitViewTransitionsHandlerImpl: TransitionsCoordinatorStorer {
    var transitionsCoordinator: TransitionsCoordinator {
        return transitionsCoordinatorPrivate
    }
}

//MARK: - TransitionsHandlersContainer
extension SplitViewTransitionsHandlerImpl: TransitionsHandlersContainer {
    var allTransitionsHandlers: [TransitionsHandler]? {
        return transitionsHandlers
    }
    
    var visibleTransitionsHandlers: [TransitionsHandler]? {
        return transitionsHandlers
    }
}

// MARK: - helpers
private extension SplitViewTransitionsHandlerImpl {
    var transitionsHandlers: [TransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].flatMap { $0 }
    }
}