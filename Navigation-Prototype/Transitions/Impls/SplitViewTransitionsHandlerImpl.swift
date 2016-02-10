import UIKit

final class SplitViewTransitionsHandlerImpl {
    private weak var splitViewController: UISplitViewController?
   
    let transitionsCoordinator: TransitionsCoordinator
    
    init(splitViewController: UISplitViewController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.splitViewController = splitViewController
        self.transitionsCoordinator = transitionsCoordinator
    }
    
    var masterTransitionsHandler: TransitionsHandler?
    var detailTransitionsHandler: TransitionsHandler?
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandlerImpl: TransitionsHandler { }

//MARK: - TransitionsCoordinatorHolder
extension SplitViewTransitionsHandlerImpl: TransitionsCoordinatorHolder {}

//MARK: - TransitionsHandlerContainer
extension SplitViewTransitionsHandlerImpl: TransitionsHandlerContainer {
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