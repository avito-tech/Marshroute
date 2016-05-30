import Foundation

final class AuthorizationPresenter: AuthorizationModuleInput {
    // MARK: - Private properties
    private let interactor: AuthorizationInteractor
    private let router: AuthorizationRouter
    private var isAuthorized = false
    
    // MARK: - Init
    init(interactor: AuthorizationInteractor, router: AuthorizationRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Deinit
    deinit {
        onComplete?(isAuthorized: isAuthorized)
    }
    
    // MARK: - Weak properties
    weak var view: AuthorizationViewInput? {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Private
    private func setupView() {
        view?.onSubmitButtonTap = { [weak self] in
            self?.isAuthorized = true
            self?.router.dismissCurrentModule()
        }
        
        view?.onCancelButtonTap = { [weak self] in
            self?.isAuthorized = false
            self?.router.dismissCurrentModule()
        }
    }
    
    // MARK: - AuthorizationModuleInput
    var onComplete: ((isAuthorized: Bool) -> ())?
}