import UIKit

final class SplitViewTransitionsHandlerImpl: ContainingTransitionsHandler {
    private weak var splitViewController: UISplitViewController?
    
    init(splitViewController: UISplitViewController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.splitViewController = splitViewController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }
    
    var masterTransitionsHandler: AnimatingTransitionsHandler?
    var detailTransitionsHandler: AnimatingTransitionsHandler?
    
    //MARK: - TransitionsHandlerContainer
    override var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return transitionsHandlers // все == видимые
    }
    
    override var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return transitionsHandlers // все == видимые
    }
}

// MARK: - helpers
private extension SplitViewTransitionsHandlerImpl {
    var transitionsHandlers: [AnimatingTransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].flatMap { $0 }
    }
}