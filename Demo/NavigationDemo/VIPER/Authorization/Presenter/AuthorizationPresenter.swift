import Foundation

final class AuthorizationPresenter {
    // MARK: - Init
    private let interactor: AuthorizationInteractor
    
    private let router: AuthorizationRouter
    
    private var isAuthorized = false
    
    init(interactor: AuthorizationInteractor, router: AuthorizationRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: AuthorizationViewInput? {
        didSet {
            setupView()
        }
    }
    
    weak var moduleOutput: AuthorizationModuleOutput?
    
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
    
    deinit {
        moduleOutput?.autorizationModuleDidFinish(isAuthorized: isAuthorized)
    }
}