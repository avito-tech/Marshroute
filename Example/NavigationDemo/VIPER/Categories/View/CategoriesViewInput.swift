import Foundation

struct CategoriesViewData {
    let title: String
    let onTap: () -> ()
}

protocol CategoriesViewInput: class, ViewLifecycleObservable {
    func setCategories(categories: [CategoriesViewData])
    func setTitle(title: String?)
    
    func setTimerButtonVisible(visible: Bool)
    func setTimerButtonEnabled(enabled: Bool)
    func setTimerButtonTitle(title: String)
    
    var onDismissButtonTap: (() -> ())? { get set }
    var onTimerButtonTap: (() -> ())? { get set }
}
