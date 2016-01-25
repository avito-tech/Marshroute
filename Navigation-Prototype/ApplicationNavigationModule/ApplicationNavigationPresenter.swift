import Foundation

class ApplicationNavigationPresenter {
    private let interactor: ApplicationNavigationInteractor
    private let router: ApplicationNavigationRouter
    
    weak var viewInput: ApplicationNavigationViewInput?
    
    //MARK: - Init
    init(interactor: ApplicationNavigationInteractor, router: ApplicationNavigationRouter){
        self.interactor = interactor
        self.router = router
    }
    
}

//MARK: - ApplicationNavigationInput
extension ApplicationNavigationPresenter: ApplicationNavigationModuleInput  {
    func showAuthorizationModule() {
        router.showAuthorization()
    }
}

//MARK: - ApplicationNavigationViewOutput
extension ApplicationNavigationPresenter: ApplicationNavigationViewOutput  {
    
}