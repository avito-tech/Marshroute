import UIKit

public protocol PeekAndPopStateObservable: class {
    func addObserver(
        disposable: AnyObject,
        onPeekAndPopStateChange: @escaping ((_ viewController: UIViewController, _ isInPeekState: Bool) -> ()))
}

public protocol PeekAndPopStateViewControllerObservable: class {
    func addObserver(
        disposableViewController: UIViewController,
        onPeekAndPopStateChange: @escaping ((_ isInPeekState: Bool) -> ()))
}

public extension PeekAndPopStateViewControllerObservable where Self: PeekAndPopStateObservable {
    func addObserver(
        disposableViewController: UIViewController,
        onPeekAndPopStateChange: @escaping ((_ isInPeekState: Bool) -> ()))
    {
        addObserver(
            disposable: disposableViewController,
            onPeekAndPopStateChange: { [weak disposableViewController] viewController, isInPeekState in
                if disposableViewController == viewController {
                    onPeekAndPopStateChange(isInPeekState)
                }
            }
        )
    }
}
