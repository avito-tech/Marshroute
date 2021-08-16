import Foundation

protocol CategoriesInteractor: AnyObject {
    func category(_ completion: () -> ())
    func categoryTitle(_ completion: (_ title: String?) -> ())
    func subcategories(_ completion: (_ subcategories: [Category]) -> ())
    func subCategoryStatus(_ category: Category, completion: (_ categoryId: CategoryId, _ hasSubcategories: Bool) -> ())
    
    func timerStatus(_ completion: (_ isEnabled: Bool) -> ())
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?)
}
