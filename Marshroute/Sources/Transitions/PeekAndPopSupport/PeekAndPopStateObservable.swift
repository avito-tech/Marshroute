import UIKit

/// Use this protocol to observe any view controller's `peek and pop` state changes.
/// This may be useful for analytics purposes.
/// See also `PeekAndPopStateViewControllerObservable`
public protocol PeekAndPopStateObservable: class {
    func addObserver(
        disposable: AnyObject,
        onPeekAndPopStateChange: @escaping ((_ viewController: UIViewController, _ peekAndPopState: PeekAndPopState) -> ()))
}

/// Use this protocol to observe your view controller's `peek and pop` state changes.
/// This may be useful for adjusting view controller's appearance in `peek` and `popped` modes.
/// See also `PeekAndPopStateObservable`
public protocol PeekAndPopStateViewControllerObservable: class {
    func addObserver(
        disposableViewController: UIViewController,
        onPeekAndPopStateChange: @escaping ((_ peekAndPopState: PeekAndPopState) -> ()))
}

public extension PeekAndPopStateViewControllerObservable where Self: PeekAndPopStateObservable {
    func addObserver(
        disposableViewController: UIViewController,
        onPeekAndPopStateChange: @escaping ((_ peekAndPopState: PeekAndPopState) -> ()))
    {
        addObserver(
            disposable: disposableViewController,
            onPeekAndPopStateChange: { [weak disposableViewController] viewController, peekAndPopState in
                if disposableViewController === viewController {
                    onPeekAndPopStateChange(peekAndPopState)
                }
            }
        )
    }
}
