import UIKit

final public class SplitViewTransitionsHandlerImpl: ContainingTransitionsHandler {
    public private(set) weak var splitViewController: UISplitViewController?
    
    public init(
        splitViewController: UISplitViewController?,
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
    
    // MARK: - Public
    public final func setSplitViewController(_ splitViewController: UISplitViewController) {
        if let splitViewController = self.splitViewController {
            debugPrint("You should not edit `splitViewController` if it has already been set. Aborting")
        } else {
            self.splitViewController = splitViewController
        }
    }
    
    // MARK: - Private
    private var bothTransitionsHandlers: [AnimatingTransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].flatMap { $0 }
    }
}
