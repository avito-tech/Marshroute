import Foundation

final class CategoriesPresenter {
    // MARK: - Init
    private let interactor: CategoriesInteractor
    private let router: CategoriesRouter
    
    init(interactor: CategoriesInteractor, router: CategoriesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: CategoriesViewInput? {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Private
    private func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.interactor.category {
                self?.interactor.categoryTitle { title in
                    self?.view?.setTitle(title)
                }
                
                self?.interactor.subCategories { subCategories in
                    if let viewCategories = self?.viewCategoriesFromInteractorCategories(subCategories) {
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
    
    private func viewCategoriesFromInteractorCategories(categories: [Category]) -> [CategoriesViewData] {
        return categories.map { viewCategoryFromCategory($0) }
    }
    
    private func viewCategoryFromCategory(category: Category) -> CategoriesViewData {
        return CategoriesViewData(
            title: category.title,
            onTap: { [weak self] in
                self?.interactor.subCategoryStatus(category) { (categoryId, hasSubCategories) in
                    if hasSubCategories {
                        self?.router.showSubCategories(categoryId: categoryId)
                    } else {
                        self?.router.showSearchResults(categoryId: categoryId)
                    }
                }
            }
        )
    }
}
