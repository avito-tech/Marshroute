import Foundation

final class ShelfPresenter {
    // MARK: - Init
    private let interactor: ShelfInteractor
    
    private let router: ShelfRouter
    
    init(interactor: ShelfInteractor, router: ShelfRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ShelfViewInput? {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Private
    private func setupView() {
        view?.onViewDidLoad = { [weak self] in
            self?.view?.setTitle("shelves".localized)
        }
    }
}
