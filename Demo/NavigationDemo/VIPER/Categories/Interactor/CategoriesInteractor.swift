import Foundation

protocol CategoriesInteractor: class {
    func category(completion: () -> ())
    func categoryTitle(completion: (title: String?) -> ())
    func subCategories(completion: (subCategories: [Category]) -> ())
    func subCategoryStatus(category: Category, completion: (categoryId: CategoryId, hasSubCategories: Bool) -> ())
    
    func timerStatus(completion: (isEnabled: Bool) -> ())
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?)
}