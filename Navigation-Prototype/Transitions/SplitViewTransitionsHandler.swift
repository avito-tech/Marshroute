import UIKit

class SplitViewTransitionsHandler {
    private unowned let splitViewController: UISplitViewController
    let transitionsCoordinator: TransitionsCoordinator
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    var masterTransitionsHandler: TransitionsHandler?
    var detailTransitionsHandler: TransitionsHandler?
}

// MARK: - TransitionsHandler
extension SplitViewTransitionsHandler: TransitionsHandler { }

//MARK: - TransitionsCoordinatorStorer
extension SplitViewTransitionsHandler: TransitionsCoordinatorStorer {}

//MARK: - TransitionsHandlersContainer
extension SplitViewTransitionsHandler: TransitionsHandlersContainer {
    var allTransitionsHandlers: [TransitionsHandler] {
        return transitionsHandlers
    }
    
    var visibleTransitionsHandlers: [TransitionsHandler] {
        return transitionsHandlers
    }
    
    private var transitionsHandlers: [TransitionsHandler] {
        var result = [TransitionsHandler]()
        
        if let masterTransitionsHandler = masterTransitionsHandler {
            result.append(masterTransitionsHandler)
        }
        if let detailTransitionsHandler = detailTransitionsHandler {
            result.append(detailTransitionsHandler)
        }
        
        return result
    }
}