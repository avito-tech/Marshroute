import UIKit

public protocol PeekAndPopStateObservable: class {
    func addObserver(
        disposable: AnyObject,
        onPeekAndPopStateChange: @escaping ((_ viewController: UIViewController, _ peekAndPopState: PeekAndPopState) -> ()))
}

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
