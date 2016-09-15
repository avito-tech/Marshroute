import Foundation

final class CategoriesInteractorImpl: CategoriesInteractor {
    fileprivate let categoriesProvider: CategoriesProvider
    fileprivate let categoryId: CategoryId?
    fileprivate var timerService: TimerService?
    
    // MARK: - Init
    init(categoryId: CategoryId?, categoriesProvider: CategoriesProvider, timerService: TimerService?) {
        self.categoryId = categoryId
        self.categoriesProvider = categoriesProvider
        self.timerService = timerService
    }
    
    // MARK: - Private propeties
    fileprivate var category: Category?
    
    // MARK: - CategoriesInteractor
    func category(_ completion: () -> ()) {
        if let categoryId = categoryId {
            category = categoriesProvider.categoryForId(categoryId)
        } else {
            category = categoriesProvider.topCategory()
        }
        completion()
    }
    
    func categoryTitle(_ completion: (_ title: String?) -> ()) {
        completion(category?.title)
    }
    
    func subcategories(_ completion: (_ subcategories: [Category]) -> ()) {
        completion(category?.subcategories ?? [])
    }
    
    func subCategoryStatus(_ subCategory: Category, completion: (_ categoryId: CategoryId, _ hasSubcategories: Bool) -> ()) {
        completion(subCategory.id, subCategory.subcategories?.isEmpty == false)
    }
    
    func timerStatus(_ completion: (_ isEnabled: Bool) -> ()) {
        completion(timerService != nil)
    }
    
    func startTimer(onTick: ((_ secondsLeft: TimeInterval) -> ())?, onFire: (() -> ())?) {
        timerService?.startTimer(seconds: 6, onTick: onTick, onFire: onFire)
    }
}
