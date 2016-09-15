import UIKit

final public class SplitViewTransitionsHandlerImpl: ContainingTransitionsHandler {
    fileprivate weak var splitViewController: UISplitViewController?
    
    public init(splitViewController: UISplitViewController,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.splitViewController = splitViewController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }
    
    public var masterTransitionsHandler: AnimatingTransitionsHandler?
    public var detailTransitionsHandler: AnimatingTransitionsHandler?
    
    // MARK: - TransitionsHandlerContainer
    override public var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return bothTransitionsHandlers // все == видимые
    }
    
    override public var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        return bothTransitionsHandlers // все == видимые
    }
}

// MARK: - helpers
private extension SplitViewTransitionsHandlerImpl {
    var bothTransitionsHandlers: [AnimatingTransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].flatMap { $0 }
    }
}
