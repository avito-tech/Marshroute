import Foundation

class ApplicationNavigationPresenter {
    private let interactor: ApplicationNavigationInteractor
    var router: ApplicationNavigationRouter?
    
    weak var viewInput: ApplicationNavigationViewInput?
    
    weak var authInput: AuthorizationModuleInput?
    
    //MARK: - Init
    init(interactor: ApplicationNavigationInteractor){
        self.interactor = interactor
    }
}

//MARK: - ApplicationNavigationInput
extension ApplicationNavigationPresenter: ApplicationNavigationModuleInput  {
    func showAuthorizationModule() {
        router?.showAuthorization()
    }
}

//MARK: - ApplicationNavigationViewOutput
extension ApplicationNavigationPresenter: ApplicationNavigationViewOutput  {
    
}