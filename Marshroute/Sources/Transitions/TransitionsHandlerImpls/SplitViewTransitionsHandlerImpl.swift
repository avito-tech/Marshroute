import UIKit


public protocol SplitViewControllerProtocol: AnyObject {
    var viewControllers: [UIViewController] { get set }
}

extension UISplitViewController: SplitViewControllerProtocol {}

public protocol SplitViewTransitionsHandler: ContainingTransitionsHandler {
    var masterTransitionsHandler: AnimatingTransitionsHandler? { get set }
    var detailTransitionsHandler: AnimatingTransitionsHandler? { get set }
}

final public class SplitViewTransitionsHandlerImpl: BaseContainingTransitionsHandler, SplitViewTransitionsHandler {
    private weak var splitViewController: SplitViewControllerProtocol?
    
    public init(splitViewController: SplitViewControllerProtocol,
        transitionsCoordinator: TransitionsCoordinator)
    {
        self.splitViewController = splitViewController
        super.init(transitionsCoordinator: transitionsCoordinator)
    }
    
    public var masterTransitionsHandler: AnimatingTransitionsHandler?
    public var detailTransitionsHandler: AnimatingTransitionsHandler?
    
    // MARK: - TransitionsHandlerContainer
    override public var allTransitionsHandlers: [AnimatingTransitionsHandler]? {
        // все и видимые для сплитвью считаем одним и и тем же (хотя у сплит вью и можно спрятать master)
        return bothTransitionsHandlers
    }
    
    override public var visibleTransitionsHandlers: [AnimatingTransitionsHandler]? {
        // все и видимые для сплитвью считаем одним и и тем же (хотя у сплит вью и можно спрятать master)
        return bothTransitionsHandlers
    }
}

// MARK: - helpers
private extension SplitViewTransitionsHandlerImpl {
    var bothTransitionsHandlers: [AnimatingTransitionsHandler] {
        return [masterTransitionsHandler, detailTransitionsHandler].compactMap { $0 }
    }
}
