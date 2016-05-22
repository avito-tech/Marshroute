import Foundation

protocol RecursionViewInput: class, ViewLifecycleObservable {
    func setTitle(title: String?)
    
    func setTimerButtonVisible(visible: Bool)
    func setTimerButtonEnabled(enabled: Bool)
    func setTimerButtonTitle(title: String)
    
    var onRecursionButtonTap: ((sender: AnyObject) -> ())? { get set }
    var onDismissButtonTap: (() -> ())? { get set }
    var onCategoriesButtonTap: ((sender: AnyObject) -> ())? { get set }
    var onTimerButtonTap: (() -> ())? { get set }
}
