import Foundation

protocol RecursionViewInput: AnyObject, ViewLifecycleObservable {
    func setTitle(_ title: String?)
    
    func setTimerButtonVisible(_ visible: Bool)
    func setTimerButtonEnabled(_ enabled: Bool)
    func setTimerButtonTitle(_ title: String)
    
    var onRecursionButtonTap: ((_ sender: AnyObject) -> ())? { get set }
    var onDismissButtonTap: (() -> ())? { get set }
    var onCategoriesButtonTap: ((_ sender: AnyObject) -> ())? { get set }
    var onTimerButtonTap: (() -> ())? { get set }
}
