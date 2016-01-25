import Foundation

class ApplicationPresenter {
    private let interactor: ApplicationInteractor
    
    weak var navigationModuleInput: ApplicationNavigationModuleInput?
    
    //MARK: - Init
    init(interactor: ApplicationInteractor){
        self.interactor = interactor
    }
    
}

//MARK: - ApplicationInput
extension ApplicationPresenter: ApplicationModuleInput  {
    func showAuthorizationModule(closure: ((authorized: Bool) -> Void)?) {
        if interactor.shouldShowAuthorizationModule {
            interactor.shouldShowAuthorizationModule = false
            navigationModuleInput?.showAuthorizationModule()
        }

        interactor.setAuthorizationCompletionBlock(closure)
    }

}
//MARK: - ApplicationNavigationModuleOutput
extension ApplicationPresenter: ApplicationNavigationModuleOutput {
    func didHideAuthorizationModule(authorized: Bool) {
        interactor.shouldShowAuthorizationModule = true
        interactor.executeAuthorizationCompletionBlockAndDeleteAfterExecution(authorized)
    }
}
