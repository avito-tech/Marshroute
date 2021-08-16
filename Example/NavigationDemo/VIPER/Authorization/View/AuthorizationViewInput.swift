import Foundation

protocol AuthorizationViewInput: AnyObject, ViewLifecycleObservable {
    var onCancelButtonTap: (() -> ())? { get set }
    var onSubmitButtonTap: (() -> ())? { get set }
}
