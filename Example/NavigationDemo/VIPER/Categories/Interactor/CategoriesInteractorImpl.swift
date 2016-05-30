import Foundation

final class CategoriesInteractorImpl: CategoriesInteractor {
    private let categoriesProvider: CategoriesProvider
    private let categoryId: CategoryId?
    private var timerService: TimerService?
    
    // MARK: - Init
    init(categoryId: CategoryId?, categoriesProvider: CategoriesProvider, timerService: TimerService?) {
        self.categoryId = categoryId
        self.categoriesProvider = categoriesProvider
        self.timerService = timerService
    }
    
    // MARK: - Private propeties
    private var category: Category?
    
    // MARK: - CategoriesInteractor
    func category(completion: () -> ()) {
        if let categoryId = categoryId {
            category = categoriesProvider.categoryForId(categoryId)
        } else {
            category = categoriesProvider.topCategory()
        }
        completion()
    }
    
    func categoryTitle(completion: (title: String?) -> ()) {
        completion(title: category?.title)
    }
    
    func subcategories(completion: (subcategories: [Category]) -> ()) {
        completion(subcategories: category?.subcategories ?? [])
    }
    
    func subCategoryStatus(subCategory: Category, completion: (categoryId: CategoryId, hasSubcategories: Bool) -> ()) {
        completion(categoryId: subCategory.id, hasSubcategories: subCategory.subcategories?.isEmpty == false)
    }
    
    func timerStatus(completion: (isEnabled: Bool) -> ()) {
        completion(isEnabled: timerService != nil)
    }
    
    func startTimer(onTick onTick: ((secondsLeft: NSTimeInterval) -> ())?, onFire: (() -> ())?) {
        timerService?.startTimer(seconds: 6, onTick: onTick, onFire: onFire)
    }
}
