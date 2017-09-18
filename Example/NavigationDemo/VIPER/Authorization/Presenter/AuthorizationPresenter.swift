import Foundation

final class AuthorizationPresenter: AuthorizationModuleInput {
    // MARK: - Private properties
    fileprivate let interactor: AuthorizationInteractor
    fileprivate let router: AuthorizationRouter
    fileprivate var isAuthorized = false
    
    // MARK: - Init
    init(interactor: AuthorizationInteractor, router: AuthorizationRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Deinit
    deinit {
        onComplete?(isAuthorized)
    }
    
    // MARK: - Weak properties
    weak var view: AuthorizationViewInput? {
        didSet {
            if oldValue !== view {
                setupView()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func setupView() {
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
    var onComplete: ((_ isAuthorized: Bool) -> ())?
}
