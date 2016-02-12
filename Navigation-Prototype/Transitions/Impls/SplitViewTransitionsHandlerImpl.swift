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
    
    var masterTransitionsHandler: AnimatingTransitionsHandler?
    var detailTransitionsHandler: AnimatingTransitionsHandler?
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandlerImpl: TransitionsHandler { }

//MARK: - TransitionsCoordinatorHolder
extension SplitViewTransitionsHandlerImpl: TransitionsCoordinatorHolder {}

//MARK: - TransitionsHandlerContainer
extension SplitViewTransitionsHandlerImpl: TransitionsHandlerContainer {
    var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return transitionsHandlers
    }
    
    var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return transitionsHandlers
    }
}

// MARK: - helpers
private extension SplitViewTransitionsHandlerImpl {
    var transitionsHandlers: [AnimatingTransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].flatMap { $0 }
    }
}