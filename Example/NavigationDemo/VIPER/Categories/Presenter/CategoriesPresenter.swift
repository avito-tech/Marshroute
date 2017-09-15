import Foundation

final class CategoriesPresenter {
    // MARK: - Init
    fileprivate let interactor: CategoriesInteractor
    fileprivate let router: CategoriesRouter
    
    init(interactor: CategoriesInteractor, router: CategoriesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: CategoriesViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.interactor.category {
                self?.interactor.categoryTitle { title in
                    self?.view?.setTitle(title)
                }
                
                self?.interactor.subcategories { subcategories in
                    if let viewCategories = self?.viewCategoriesFromInteractorCategories(subcategories) {
                        self?.view?.setCategories(viewCategories)
                    }
                }
            }
            
            self?.interactor.timerStatus { isEnabled in
                self?.view?.setTimerButtonVisible(isEnabled)
                
                if isEnabled {
                    self?.view?.setTimerButtonTitle("comebackTimer.startTimerTitle".localized)
                    
                    self?.view?.onTimerButtonTap = {
                        self?.view?.setTimerButtonEnabled(false)
                        
                        self?.interactor.startTimer(
                            onTick: { secondsLeft in
                                self?.view?.setTimerButtonTitle(
                                    "comebackTimer.secondsLeftTillComeback"
                                        .localizedWithArgument(Int(secondsLeft) as NSNumber)
                                )
                            },
                            onFire: {
                                self?.view?.setTimerButtonEnabled(true)
                                self?.view?.setTimerButtonTitle("comebackTimer.startTimerTitle".localized)
                                self?.router.returnToCategories()
                            }
                        )
                    }
                }
            }
        }
        
        view?.onDismissButtonTap = { [weak self] in
            self?.router.dismissCurrentModule()
        }
    }
    
    fileprivate func viewCategoriesFromInteractorCategories(_ categories: [Category]) -> [CategoriesViewData] {
        return categories.map { viewCategoryFromCategory($0) }
    }
    
    fileprivate func viewCategoryFromCategory(_ category: Category) -> CategoriesViewData {
        return CategoriesViewData(
            title: category.title,
            onTap: { [weak self] in
                self?.interactor.subCategoryStatus(category) { (categoryId, hasSubcategories) in
                    if hasSubcategories {
                        self?.router.showSubcategories(categoryId: categoryId)
                    } else {
                        self?.router.showSearchResults(categoryId: categoryId)
                    }
                }
            }
        )
    }
}
