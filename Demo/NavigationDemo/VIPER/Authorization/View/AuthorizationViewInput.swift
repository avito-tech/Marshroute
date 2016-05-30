import Foundation

protocol AuthorizationViewInput: class, ViewLifecycleObservable {
    var onCancelButtonTap: (() -> ())? { get set }
    var onSubmitButtonTap: (() -> ())? { get set }
}
