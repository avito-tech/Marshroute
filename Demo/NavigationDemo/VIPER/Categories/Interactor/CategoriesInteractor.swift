import Foundation

protocol CategoriesInteractor: class {
    func category(completion: () -> ())
    func categoryTitle(completion: (title: String?) -> ())
    func subcategories(completion: (subcategories: [Category]) -> ())
    func subCategoryStatus(category: Category, completion: (categoryId: CategoryId, hasSubcategories: Bool) -> ())
    
    func timerStatus(completion: (isEnabled: Bool) -> ())
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?)
}