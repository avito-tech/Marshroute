import Foundation

final class ShelfPresenter {
    // MARK: - Init
    fileprivate let interactor: ShelfInteractor
    
    fileprivate let router: ShelfRouter
    
    init(interactor: ShelfInteractor, router: ShelfRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ShelfViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.view?.setTitle("shelves".localized)
        }
    }
}
