import Foundation

class AuthorizationPresenter {
    private let interactor: AuthorizationInteractor
    private let router: AuthorizationRouter
    
    weak var viewInput: AuthorizationViewInput?
    
    //MARK: - Init
    init(interactor: AuthorizationInteractor, router: AuthorizationRouter){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - AuthorizationInput
extension AuthorizationPresenter: AuthorizationModuleInput  {
    
}

//MARK: - AuthorizationViewOutput
extension AuthorizationPresenter: AuthorizationViewOutput  {
    
}