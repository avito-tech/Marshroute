import Foundation

struct CategoriesViewData {
    let title: String
    let onTap: () -> ()
}

protocol CategoriesViewInput: AnyObject, ViewLifecycleObservable {
    func setCategories(_ categories: [CategoriesViewData])
    func setTitle(_ title: String?)
    
    func setTimerButtonVisible(_ visible: Bool)
    func setTimerButtonEnabled(_ enabled: Bool)
    func setTimerButtonTitle(_ title: String)
    
    var onDismissButtonTap: (() -> ())? { get set }
    var onTimerButtonTap: (() -> ())? { get set }
}
